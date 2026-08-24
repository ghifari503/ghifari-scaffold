#!/usr/bin/env node
// Standalone AI/runtime/process-trace leakage scanner for an adopted target repository.
//
// This file is self-contained on purpose: once copied into a target repository (for example
// to scripts/odn-leakage-scan.mjs) it must keep working even if that repository is cloned or
// hosted completely independently of the Master Scaffold. It intentionally duplicates the
// target-facing detection rules from the Master Scaffold's scripts/odn-traceability.mjs
// leakageGate() instead of importing it.
//
// Usage:
//   node odn-leakage-scan.mjs                  scan the whole working tree (CI use)
//   node odn-leakage-scan.mjs --staged         scan only Git-staged files (pre-commit use)
//   node odn-leakage-scan.mjs --path <dir>     scan a specific directory

import { execFileSync } from 'node:child_process';
import * as fs from 'node:fs/promises';
import path from 'node:path';

const INTERNAL_NAMES = new Set(['ACTIVE_CONTEXT.md', 'CONTRIBUTOR_LOG.md', 'AI_ROUTING_LOG.md']);
const INTERNAL_PATHS = [
  /(?:^|\/)handoffs(?:\/|$)/i,
  /(?:^|\/)scaffold-updates(?:\/|$)/i,
  /(?:^|\/)(?:lifecycle|routing|contributor|process|development)[-_](?:state|log|metadata)(?:\.|\/|$)/i,
];
const INTERNAL_METADATA = /^(?:\s*[-*]\s*)?(?:["']?)(?:odn_id|odn_source|source_marker|batch_key|active_batch|internal_handoff|handoff_path|lifecycle_state|lifecycle_reference|routing_profile|model_source|model_or_profile|token_band|cost_band|activity_log_entry|allowed_write_paths|blocked_paths|do_not_repeat|resume_safe)(?:["']?)\s*[:=]/im;
// Protect internal operating provenance without treating normal product AI terms as
// leakage. A target may legitimately contain an AI model/provider/token/agent or
// configuration for one; only named runtime tools and explicit process provenance
// are relevant to this share gate.
const TARGET_RUNTIME_TOOL_TRACE = /\b(?:codex\s+cli|claude\s+code|gemini\s+cli)\b/i;
const TARGET_RUNTIME_PROVENANCE_TRACE = /\b(?:generated|authored|implemented|reviewed|maintained|created|written|handoff(?:ed)?|routed)\s+(?:by|with|using|from)\s+(?:the\s+)?(?:codex|claude|gemini|openai|anthropic|llm)\b/i;
const TARGET_RUNTIME_IDENTITY_FIELD = /^(?:\s*[-*]\s*)?(?:["']?)(?:runtime|started_by_runtime|last_updated_by_runtime|handoff_from|handoff_to|agent_role|owner_runtime|routing_profile|routing_log_reference)(?:["']?)\s*[:=].*\b(?:codex|claude|gemini|openai|anthropic|llm)\b/im;
const TARGET_SCAN_EXCLUDES = new Set(['.git', 'node_modules', 'dist', 'build', 'coverage', '.next', 'graphify-out']);
const TEXT_EXTENSIONS = new Set(['.md', '.json', '.yaml', '.yml', '.toml', '.txt', '.ini', '.cfg']);
// Explicit trace detection covers the whole tree (any non-binary file), not just doc/config
// extensions, so a stray trace comment in source code is still caught. TEXT_EXTENSIONS above
// stays narrow because it is only used for the internal-metadata-field check, which should
// only fire on structured doc/config files.
const BINARY_SCAN_EXCLUDE_EXTENSIONS = new Set([
  '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.bmp', '.avif', '.tiff',
  '.pdf', '.zip', '.gz', '.tgz', '.tar', '.7z', '.rar', '.br',
  '.woff', '.woff2', '.ttf', '.otf', '.eot',
  '.mp3', '.mp4', '.mov', '.avi', '.wav', '.ogg', '.webm',
  '.exe', '.dll', '.so', '.dylib', '.class', '.jar', '.wasm', '.node', '.bin', '.dat',
  '.sqlite', '.sqlite3', '.db',
]);
const ALLOWED_PROVENANCE = /@batch\s+odn-[0-9]+|Batch:\s+odn-[0-9]+/;

function normalizeRelative(root, file) {
  return path.relative(root, file).split(path.sep).join('/');
}

async function listTree(root) {
  const output = [];
  async function walk(directory) {
    let entries;
    try { entries = await fs.readdir(directory, { withFileTypes: true }); } catch { return; }
    for (const entry of entries) {
      if (entry.isDirectory()) { if (!TARGET_SCAN_EXCLUDES.has(entry.name)) await walk(path.join(directory, entry.name)); continue; }
      if (entry.isFile()) output.push(path.join(directory, entry.name));
    }
  }
  await walk(root);
  return output;
}

function listStaged(root) {
  try {
    const output = execFileSync('git', ['-C', root, 'diff', '--cached', '--name-only', '--diff-filter=ACM'], { encoding: 'utf8' });
    return output.split(/\r?\n/).filter(Boolean).map((relative) => path.join(root, relative));
  } catch {
    return [];
  }
}

async function scanFile(root, file) {
  const relative = normalizeRelative(root, file);
  const name = path.basename(file);
  const findings = [];
  if (INTERNAL_NAMES.has(name)) findings.push({ path: relative, reason: `reserved internal filename ${name}` });
  if (INTERNAL_PATHS.some((pattern) => pattern.test(relative))) findings.push({ path: relative, reason: 'reserved internal lifecycle/process path' });
  if (BINARY_SCAN_EXCLUDE_EXTENSIONS.has(path.extname(file).toLowerCase())) return findings;
  let buffer;
  try { buffer = await fs.readFile(file); } catch { return findings; }
  if (buffer.includes(0)) return findings; // binary content sniff for files without a recognized extension
  const content = buffer.toString('utf8');
  if (TEXT_EXTENSIONS.has(path.extname(file).toLowerCase()) && INTERNAL_METADATA.test(content)) {
    findings.push({ path: relative, reason: 'targeted internal metadata field' });
  }
  const withoutAllowed = content.replace(new RegExp(ALLOWED_PROVENANCE, 'g'), '');
  const traceMatch = withoutAllowed.match(TARGET_RUNTIME_TOOL_TRACE)
    || withoutAllowed.match(TARGET_RUNTIME_PROVENANCE_TRACE)
    || withoutAllowed.match(TARGET_RUNTIME_IDENTITY_FIELD);
  if (traceMatch) findings.push({ path: relative, reason: `explicit internal runtime/process provenance: ${traceMatch[0]}` });
  return findings;
}

async function main() {
  const args = process.argv.slice(2);
  const root = process.cwd();
  let files;
  if (args.includes('--staged')) {
    files = listStaged(root);
  } else {
    const pathIndex = args.indexOf('--path');
    const scanRoot = pathIndex >= 0 && args[pathIndex + 1] ? path.resolve(root, args[pathIndex + 1]) : root;
    files = await listTree(scanRoot);
  }
  const findings = [];
  for (const file of files) {
    const exists = await fs.stat(file).then(() => true).catch(() => false);
    if (!exists) continue;
    findings.push(...(await scanFile(root, file)));
  }
  const result = { status: findings.length ? 'FAIL' : 'PASS', explicit_ai_trace_and_leakage_findings: findings };
  process.stdout.write(`${JSON.stringify(result, null, 2)}\n`);
  if (result.status === 'FAIL') process.exitCode = 2;
}

main().catch((error) => {
  process.stderr.write(`ODN_LEAKAGE_SCAN_ERROR: ${error.message}\n`);
  process.exitCode = 1;
});
