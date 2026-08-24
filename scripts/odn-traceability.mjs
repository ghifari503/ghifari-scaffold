#!/usr/bin/env node

import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { constants } from 'node:fs';
import * as fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptRoot = path.dirname(fileURLToPath(import.meta.url));
const defaultMaster = path.resolve(scriptRoot, '..');
const ODN_SCHEMA_VERSION = 4;
const INTERNAL_NAMES = new Set(['ACTIVE_CONTEXT.md', 'CONTRIBUTOR_LOG.md', 'AI_ROUTING_LOG.md']);
const INTERNAL_PATHS = [
  /(?:^|\/)handoffs(?:\/|$)/i,
  /(?:^|\/)scaffold-updates(?:\/|$)/i,
  /(?:^|\/)(?:lifecycle|routing|contributor|process|development)[-_](?:state|log|metadata)(?:\.|\/|$)/i,
];
const INTERNAL_METADATA = /^(?:\s*[-*]\s*)?(?:["']?)(?:odn_id|odn_source|source_marker|batch_key|active_batch|internal_handoff|handoff_path|lifecycle_state|lifecycle_reference|routing_profile|model_source|model_or_profile|token_band|cost_band|activity_log_entry|allowed_write_paths|blocked_paths|do_not_repeat|resume_safe)(?:["']?)\s*[:=]/im;
const INTERNAL_AUTHORITY_PATH = /(?:odn:\/\/[a-z0-9._-]+\/odn-[0-9]+|artifacts[\\/]traceability[\\/]|artifacts[\\/]operations[\\/]|artifacts[\\/]memory[\\/]|artifacts[\\/]shared[\\/](?:ACTIVE_CONTEXT\.md|CONTRIBUTOR_LOG\.md|AI_ROUTING_LOG\.md|handoffs[\\/]|scaffold-updates[\\/]))/i;
const TEXT_EXTENSIONS = new Set(['.md', '.json', '.yaml', '.yml', '.toml', '.txt', '.ini', '.cfg']);
const PREVENTION_START = '# BEGIN MASTER-SCAFFOLD-INTERNAL-STATE';
const PREVENTION_END = '# END MASTER-SCAFFOLD-INTERNAL-STATE';
const PREVENTION_RULES = [
  'artifacts/shared/ACTIVE_CONTEXT.md',
  'artifacts/shared/CONTRIBUTOR_LOG.md',
  'artifacts/shared/AI_ROUTING_LOG.md',
  'artifacts/shared/handoffs/',
  'artifacts/shared/scaffold-updates/',
  'artifacts/shared/*-lifecycle-state*',
  'artifacts/shared/*-routing-metadata*',
  'artifacts/shared/*-process-state*',
];
const IDENTITY_FIELD_PATTERN = /^(?:\s*[-*]\s*)?(?:["']?)(?:runtime|started_by_runtime|last_updated_by_runtime|handoff_from|handoff_to|agent_role|model|model_or_profile|model_source|model_availability_reason|provider|vendor|routing_profile|routing_log_reference|token_band|cost_band)(?:["']?)\s*[:=]/im;
const IDENTITY_METADATA_LINE_PATTERN = /^(?:\s*[-*]\s*)?(?:["']?)(?:runtime|started_by_runtime|last_updated_by_runtime|handoff_from|handoff_to|agent_role|owner_runtime|model|model_or_profile|model_source|model_availability_reason|provider|vendor|routing_profile|routing_log_reference|token_band|cost_band)(?:["']?)\s*[:=].*(?:\r?\n|$)/gim;
// A share gate protects client repositories from *internal operating provenance*,
// not from legitimate product implementation. A target may itself use AI models,
// providers, tokens, agents, or even environment variables for that product. Keep
// those ordinary domain terms out of this detector and match only high-signal runtime
// tool references or explicit authorship/process provenance instead.
const TARGET_RUNTIME_TOOL_TRACE = /\b(?:codex\s+cli|claude\s+code|gemini\s+cli)\b/i;
const TARGET_RUNTIME_PROVENANCE_TRACE = /\b(?:generated|authored|implemented|reviewed|maintained|created|written|handoff(?:ed)?|routed)\s+(?:by|with|using|from)\s+(?:the\s+)?(?:codex|claude|gemini|openai|anthropic|llm)\b/i;
const TARGET_RUNTIME_IDENTITY_FIELD = /^(?:\s*[-*]\s*)?(?:["']?)(?:runtime|started_by_runtime|last_updated_by_runtime|handoff_from|handoff_to|agent_role|owner_runtime|routing_profile|routing_log_reference)(?:["']?)\s*[:=].*\b(?:codex|claude|gemini|openai|anthropic|llm)\b/im;
const TARGET_SCAN_EXCLUDES = new Set(['.git', 'node_modules', 'dist', 'build', 'coverage', '.next', 'graphify-out']);
// The explicit AI/runtime/process trace scan covers the whole target tree, including source
// code, not only the narrow doc/config extensions used for structural artifacts/shared
// classification. Excluding known-binary extensions (rather than allow-listing text
// extensions) keeps a stray trace comment in any source file detectable.
const BINARY_SCAN_EXCLUDE_EXTENSIONS = new Set([
  '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.bmp', '.avif', '.tiff',
  '.pdf', '.zip', '.gz', '.tgz', '.tar', '.7z', '.rar', '.br',
  '.woff', '.woff2', '.ttf', '.otf', '.eot',
  '.mp3', '.mp4', '.mov', '.avi', '.wav', '.ogg', '.webm',
  '.exe', '.dll', '.so', '.dylib', '.class', '.jar', '.wasm', '.node', '.bin', '.dat',
  '.sqlite', '.sqlite3', '.db',
]);

function parseArgs(argv) {
  const [command = 'help', ...rest] = argv;
  const options = {};
  const booleans = new Set(['apply', 'json', 'remove_internal_originals']);
  for (let index = 0; index < rest.length; index += 1) {
    const item = rest[index];
    if (!item.startsWith('--')) throw new Error(`Unexpected argument: ${item}`);
    const key = item.slice(2).replaceAll('-', '_');
    if (booleans.has(key)) options[key] = true;
    else {
      const value = rest[index + 1];
      if (!value || value.startsWith('--')) throw new Error(`Missing value for ${item}`);
      options[key] = value;
      index += 1;
    }
  }
  return { command, options };
}

function safeProject(value) {
  if (!value || !/^[a-z0-9][a-z0-9._-]{0,63}$/i.test(value)) {
    throw new Error('--project must contain 1-64 letters, numbers, dot, underscore, or hyphen');
  }
  return value.toLowerCase();
}

function normalizeKeyPart(value, name) {
  if (!value) throw new Error(`--${name} is required`);
  const normalized = value.trim().toLowerCase().replace(/[^a-z0-9._-]+/g, '-').replace(/^-|-$/g, '');
  if (!normalized) throw new Error(`--${name} must contain a stable value`);
  return normalized;
}

function stableKey(component, scope) {
  return `${normalizeKeyPart(component, 'component')}:${normalizeKeyPart(scope, 'scope')}`;
}

function normalizeRelative(value) {
  return value.split(path.sep).join('/');
}

function authorityPaths(master, project) {
  const root = path.join(master, 'artifacts', 'traceability-local', project);
  return {
    root,
    state: path.join(root, 'BATCH_STATE.json'),
    index: path.join(root, 'BATCH_INDEX.json'),
    codeMap: path.join(root, 'CODE_MAP.json'),
    componentMap: path.join(root, 'COMPONENT_MAP.json'),
    batches: path.join(root, 'batches'),
    handoffs: path.join(root, 'handoffs'),
    migration: path.join(root, 'migration'),
    migrationEvidence: path.join(root, 'migration-evidence'),
    adoption: path.join(root, 'PROJECT_ADOPTION.json'),
    migrationState: path.join(root, 'MIGRATION_STATE.json'),
    lock: path.join(root, '.allocation.lock'),
  };
}

function masterSchemaPath(master) {
  return path.join(master, 'artifacts', 'traceability', 'MASTER_SCAFFOLD_SCHEMA.json');
}

function csv(value) {
  return value ? [...new Set(value.split(',').map((item) => item.trim()).filter(Boolean))] : [];
}

function renderBatchMarkdown(record) {
  const bullets = (items) => items?.length ? items.map((item) => `- ${item}`).join('\n') : '- None.';
  return `# ${record.batch_id}\n\n## Status\n\n${record.state}\n\n## Objective\n\n${record.objective || 'Not recorded.'}\n\n## Reason\n\n${record.reason || 'Not recorded.'}\n\n## Component And Scope\n\n- component: \`${record.component}\`\n- scope: \`${record.scope}\`\n\n## Acceptance Criteria\n\n${bullets(record.acceptance_criteria)}\n\n## Requirements\n\n${bullets(record.requirements)}\n\n## Architectural Decisions\n\n${bullets(record.architectural_decisions)}\n\n## Affected Files\n\n${bullets(record.affected_files)}\n\n## Affected Symbols\n\n${bullets(record.affected_symbols)}\n\n## Related Batches\n\n${bullets(record.related_batches)}\n\n## Dependencies\n\n${bullets(record.dependencies)}\n\n## Validation\n\n- status: ${record.validation_status}\n${bullets(record.validation_evidence)}\n\n## Git Provenance\n\n- trailer: \`Batch: ${record.batch_id}\`\n${bullets(record.git_provenance)}\n\n## Known Issues\n\n${bullets(record.known_issues)}\n\n## Handoff Notes\n\n${bullets(record.handoff_notes)}\n`;
}

async function exists(file) {
  try { await fs.access(file, constants.F_OK); return true; } catch { return false; }
}

async function readJson(file, fallback) {
  if (!(await exists(file))) return fallback;
  return JSON.parse(await fs.readFile(file, 'utf8'));
}

async function writeFileAtomic(file, content) {
  await fs.mkdir(path.dirname(file), { recursive: true });
  const temp = path.join(path.dirname(file), `.${path.basename(file)}.${process.pid}.${Date.now()}.${Math.random().toString(16).slice(2)}.tmp`);
  await fs.writeFile(temp, content, { encoding: 'utf8', flag: 'wx' });
  try { await fs.rename(temp, file); }
  finally { await fs.rm(temp, { force: true }); }
}

async function writeJsonAtomic(file, value) {
  await writeFileAtomic(file, `${JSON.stringify(value, null, 2)}\n`);
}

async function createJsonExclusive(file, value) {
  await fs.mkdir(path.dirname(file), { recursive: true });
  await fs.writeFile(file, `${JSON.stringify(value, null, 2)}\n`, { encoding: 'utf8', flag: 'wx' });
}

async function ensureJson(file, value) {
  if (await exists(file)) return;
  try { await createJsonExclusive(file, value); }
  catch (error) { if (error.code !== 'EEXIST') throw error; }
}

async function sha256(file) {
  const hash = createHash('sha256');
  hash.update(await fs.readFile(file));
  return hash.digest('hex');
}

function sha256Text(value) {
  return createHash('sha256').update(value, 'utf8').digest('hex');
}

async function listFiles(root) {
  if (!(await exists(root))) return [];
  const output = [];
  async function walk(directory) {
    const entries = await fs.readdir(directory, { withFileTypes: true });
    for (const entry of entries.sort((a, b) => a.name.localeCompare(b.name))) {
      const full = path.join(directory, entry.name);
      if (entry.isDirectory()) await walk(full);
      else if (entry.isFile()) output.push(full);
    }
  }
  await walk(root);
  return output;
}

async function identityGate(master) {
  // Master-side identity-freedom check only: whether continuity records (Git-carried
  // schema authority plus the Git-ignored local-only per-project store) avoid runtime,
  // provider, model, agent, or engineer identity fields. This is unrelated to leakageGate,
  // which instead checks what a target repository's own Git tree may expose.
  const roots = [
    path.join(master, 'artifacts', 'traceability'),
    path.join(master, 'artifacts', 'traceability-local'),
    path.join(master, 'artifacts', 'operations'),
  ];
  const findings = [];
  for (const root of roots) {
    for (const file of await listFiles(root)) {
      if (!TEXT_EXTENSIONS.has(path.extname(file).toLowerCase())) continue;
      const content = await fs.readFile(file, 'utf8');
      const field = content.match(IDENTITY_FIELD_PATTERN);
      if (field) findings.push({ path: normalizeRelative(path.relative(master, file)), reason: 'identity_field' });
    }
  }
  return { status: findings.length ? 'FAIL' : 'PASS', prohibited_identity_findings: findings };
}

async function bootstrap(master, project) {
  const locations = authorityPaths(master, project);
  await ensureJson(masterSchemaPath(master), {
    schema_version: ODN_SCHEMA_VERSION,
    authority: 'master-scaffold-odn',
    migration_contract: 'one-time-per-project-per-schema-version',
  });
  await Promise.all([
    fs.mkdir(locations.batches, { recursive: true }),
    fs.mkdir(locations.handoffs, { recursive: true }),
    fs.mkdir(locations.migration, { recursive: true }),
    fs.mkdir(locations.migrationEvidence, { recursive: true }),
  ]);
  await ensureJson(locations.state, { schema_version: ODN_SCHEMA_VERSION, project, active_batches: {} });
  await ensureJson(locations.index, { schema_version: ODN_SCHEMA_VERSION, project, next_number: 1, batches: [] });
  await ensureJson(locations.codeMap, { schema_version: ODN_SCHEMA_VERSION, project, entries: [] });
  await ensureJson(locations.componentMap, { schema_version: ODN_SCHEMA_VERSION, project, entries: [] });
  await ensureJson(locations.adoption, { project, schema_version: 0, migration_status: 'not_started' });
  await ensureJson(locations.migrationState, { project, from_schema: 0, to_schema: ODN_SCHEMA_VERSION, status: 'not_started' });
  return locations;
}

async function readMasterSchema(master) {
  const schema = await readJson(masterSchemaPath(master), null);
  if (!schema || !Number.isInteger(schema.schema_version) || schema.schema_version < 1) {
    throw new Error('MASTER_SCHEMA_AUTHORITY_INVALID: artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json must declare a positive schema_version');
  }
  return schema;
}

async function withAllocationLock(locations, callback) {
  let handle;
  for (let attempt = 0; attempt < 100; attempt += 1) {
    try { handle = await fs.open(locations.lock, 'wx'); break; }
    catch (error) {
      if (error.code !== 'EEXIST') throw error;
      await new Promise((resolve) => setTimeout(resolve, 25));
    }
  }
  if (!handle) throw new Error('ODN_ALLOCATION_LOCK_TIMEOUT: allocator lock remained busy for 2.5 seconds');
  try { return await callback(); }
  finally { await handle.close(); await fs.rm(locations.lock, { force: true }); }
}

async function withMigrationLock(locations, schemaVersion, callback) {
  const migrationLock = path.join(locations.root, `.migration-v${schemaVersion}.lock`);
  let handle;
  try { handle = await fs.open(migrationLock, 'wx'); }
  catch (error) {
    if (error.code === 'EEXIST') throw new Error(`MIGRATION_LOCKED: project migration for schema v${schemaVersion} is already in progress; resume or recover the existing migration.`);
    throw error;
  }
  try {
    await handle.writeFile(JSON.stringify({ schema_version: schemaVersion, status: 'in_progress', created_at: new Date().toISOString() }));
    return await callback();
  } finally {
    await handle.close();
    await fs.rm(migrationLock, { force: true });
  }
}

async function resolveBatchById(locations, batchId) {
  if (!/^odn-[0-9]+$/.test(batchId)) throw new Error(`INVALID_ODN_ID: ${batchId}`);
  const index = await readJson(locations.index, { batches: [] });
  const indexEntry = (index.batches || []).find((item) => item.batch_id === batchId);
  const batchFile = path.join(locations.batches, `${batchId}.json`);
  if (!indexEntry || !(await exists(batchFile))) throw new Error(`ODN_LOOKUP_NOT_RESOLVABLE: ${batchId}`);
  const record = await readJson(batchFile, null);
  if (!record || record.batch_id !== batchId || record.context_key !== indexEntry.context_key) {
    throw new Error(`ODN_LOOKUP_INVALID: ${batchId}`);
  }
  return record;
}

async function allocate(master, project, options) {
  const locations = await bootstrap(master, project);
  const key = stableKey(options.component, options.scope);
  return withAllocationLock(locations, async () => {
    const state = await readJson(locations.state, { schema_version: 2, project, active_batches: {} });
    const current = state.active_batches?.[key];
    if (current) {
      await resolveBatchById(locations, current.batch_id);
      return { result: 'resumed', batch_id: current.batch_id, context_key: key };
    }
    const index = await readJson(locations.index, { schema_version: 2, project, next_number: 1, batches: [] });
    let number = Math.max(1, Number(index.next_number || 1));
    let batchId;
    let batchFile;
    while (true) {
      batchId = `odn-${String(number).padStart(4, '0')}`;
      batchFile = path.join(locations.batches, `${batchId}.json`);
      if (!(await exists(batchFile)) && !(index.batches || []).some((item) => item.batch_id === batchId)) break;
      number += 1;
    }
    const now = new Date().toISOString();
    const record = {
      schema_version: 2,
      batch_id: batchId,
      uri: `odn://${project}/${batchId}`,
      context_key: key,
      component: normalizeKeyPart(options.component, 'component'),
      scope: normalizeKeyPart(options.scope, 'scope'),
      objective: options.objective || '',
      reason: options.reason || '',
      state: 'active',
      acceptance_criteria: [],
      requirements: [],
      architectural_decisions: [],
      affected_files: [],
      affected_symbols: [],
      related_batches: [],
      dependencies: [],
      validation_status: 'pending',
      validation_evidence: [],
      git_provenance: [],
      known_issues: [],
      handoff_notes: [],
      source_marker: `@batch ${batchId}`,
      git_trailer: `Batch: ${batchId}`,
      graphify_content_included: false,
      created_at: now,
      updated_at: now,
    };
    await createJsonExclusive(batchFile, record);
    await writeFileAtomic(path.join(locations.batches, `${batchId}.md`), renderBatchMarkdown(record));
    index.next_number = number + 1;
    index.batches = [...(index.batches || []), {
      batch_id: batchId,
      context_key: key,
      component: record.component,
      scope: record.scope,
      state: 'active',
      updated_at: now,
    }];
    state.active_batches = state.active_batches || {};
    state.active_batches[key] = { batch_id: batchId, state: 'active', updated_at: now };
    await writeJsonAtomic(locations.index, index);
    await writeJsonAtomic(locations.state, state);
    const componentMap = await readJson(locations.componentMap, { schema_version: 2, project, entries: [] });
    const componentEntry = componentMap.entries.find((item) => item.component === record.component) || { component: record.component, batches: [] };
    componentEntry.batches = [...new Set([...(componentEntry.batches || []), batchId])];
    componentEntry.updated_at = now;
    componentMap.entries = [...componentMap.entries.filter((item) => item.component !== record.component), componentEntry];
    await writeJsonAtomic(locations.componentMap, componentMap);
    return { result: 'allocated', batch_id: batchId, context_key: key };
  });
}

async function updateBatch(master, project, options) {
  if (!options.batch || !/^odn-[0-9]{4,}$/.test(options.batch)) throw new Error('update requires --batch odn-xxxx');
  const locations = await bootstrap(master, project);
  return withAllocationLock(locations, async () => {
    const record = await resolveBatchById(locations, options.batch);
    const append = (field, value) => { record[field] = [...new Set([...(record[field] || []), ...csv(value)])]; };
    append('acceptance_criteria', options.acceptance);
    append('requirements', options.requirements);
    append('architectural_decisions', options.adrs);
    append('affected_files', options.files);
    append('affected_symbols', options.symbols);
    append('related_batches', options.related);
    append('dependencies', options.dependencies);
    append('validation_evidence', options.evidence);
    append('known_issues', options.known_issues);
    append('handoff_notes', options.handoff_notes);
    if (options.reason) record.reason = options.reason;
    if (options.validation) {
      if (!['pending', 'pass', 'fail', 'blocked'].includes(options.validation)) throw new Error('--validation must be pending, pass, fail, or blocked');
      record.validation_status = options.validation;
    }
    if (options.commit) {
      if (!options.target) throw new Error('--target is required when adding --commit');
      const validatedTarget = await validateTarget(master, path.resolve(options.target), options._git_evidence);
      const verified = git(validatedTarget.target, ['rev-parse', '--verify', `${options.commit}^{commit}`], options._git_evidence);
      if (!verified) throw new Error(`GIT_PROVENANCE_NOT_FOUND: ${options.commit}`);
      record.git_provenance = [...new Set([...(record.git_provenance || []), verified])];
    }
    if (options.state) {
      if (!['active', 'blocked', 'completed', 'cancelled', 'superseded'].includes(options.state)) throw new Error('invalid --state');
      if (options.state === 'completed' && (record.validation_status !== 'pass' || !record.acceptance_criteria.length || !record.git_provenance.length)) {
        throw new Error('BATCH_COMPLETION_BLOCKED: acceptance criteria, validation pass, and verified Git provenance are required');
      }
      record.state = options.state;
    }
    record.updated_at = new Date().toISOString();
    await writeJsonAtomic(path.join(locations.batches, `${record.batch_id}.json`), record);
    await writeFileAtomic(path.join(locations.batches, `${record.batch_id}.md`), renderBatchMarkdown(record));

    const state = await readJson(locations.state, { schema_version: 2, project, active_batches: {} });
    if (['active', 'blocked'].includes(record.state)) state.active_batches[record.context_key] = { batch_id: record.batch_id, state: record.state, updated_at: record.updated_at };
    else delete state.active_batches[record.context_key];
    await writeJsonAtomic(locations.state, state);
    const index = await readJson(locations.index, { schema_version: 2, project, next_number: 1, batches: [] });
    const indexEntry = index.batches.find((item) => item.batch_id === record.batch_id);
    if (indexEntry) { indexEntry.state = record.state; indexEntry.updated_at = record.updated_at; }
    await writeJsonAtomic(locations.index, index);

    const codeMap = await readJson(locations.codeMap, { schema_version: 2, project, entries: [] });
    for (const affectedFile of record.affected_files) {
      let entry = codeMap.entries.find((item) => item.file === affectedFile);
      if (!entry) { entry = { file: affectedFile, component: record.component, batches: [], symbols: {} }; codeMap.entries.push(entry); }
      entry.batches = [...new Set([...(entry.batches || []), record.batch_id])];
      for (const symbol of record.affected_symbols) entry.symbols[symbol] = [...new Set([...(entry.symbols[symbol] || []), record.batch_id])];
    }
    await writeJsonAtomic(locations.codeMap, codeMap);
    return { result: 'updated', batch_id: record.batch_id, state: record.state, validation_status: record.validation_status };
  });
}

async function resolve(master, project, options) {
  const limit = options.limit === undefined ? 3 : Number(options.limit);
  if (!Number.isInteger(limit) || limit < 1 || limit > 3) throw new Error('--limit must be an integer from 1 through 3');
  if (!options.component || !options.scope) throw new Error('resolve requires --component and --scope to avoid broad batch loading');
  const locations = authorityPaths(master, project);
  const key = stableKey(options.component, options.scope);
  const index = await readJson(locations.index, { batches: [] });
  const candidates = (index.batches || [])
    .filter((item) => item.context_key === key)
    .sort((a, b) => String(b.updated_at).localeCompare(String(a.updated_at)))
    .slice(0, limit);
  const batches = [];
  for (const candidate of candidates) batches.push(await resolveBatchById(locations, candidate.batch_id));
  return { project, context_key: key, limit, count: batches.length, batches, graphify_content_included: false };
}

async function validateProvenance(options) {
  if (!options.source_file || !options.batch) throw new Error('validate-provenance requires --source-file and --batch');
  if (!/^odn-[0-9]+$/.test(options.batch)) throw new Error('--batch must use odn-xxxx format');
  const source = await fs.readFile(path.resolve(options.source_file), 'utf8');
  const markers = [...source.matchAll(/@batch\s+(odn-[0-9]+)/g)].map((match) => match[1]);
  const markerPass = markers.includes(options.batch);
  let trailer = 'not_checked';
  if (options.commit_message_file) {
    const message = await fs.readFile(path.resolve(options.commit_message_file), 'utf8');
    const trailers = [...message.matchAll(/^Batch:\s+(odn-[0-9]+)\s*$/gm)].map((match) => match[1]);
    trailer = trailers.includes(options.batch) ? 'PASS' : 'FAIL';
  }
  return {
    status: markerPass && trailer !== 'FAIL' ? 'PASS' : 'FAIL',
    source_marker: markerPass ? 'PASS' : 'FAIL',
    batch_trailer: trailer,
    batch: options.batch,
    markers_found: markers,
  };
}

function explicitClassification(content) {
  const match = content.match(/^(?:\s*[-*]\s*)?(?:["']?)traceability_class(?:["']?)\s*[:=]\s*(?:["']?)(client_safe|internal_process_state)(?:["']?)\s*[,;]?$/im);
  return match?.[1]?.toLowerCase() || '';
}

async function classifySharedFile(sharedRoot, file) {
  const relative = normalizeRelative(path.relative(sharedRoot, file));
  const name = path.basename(file);
  const isText = TEXT_EXTENSIONS.has(path.extname(file).toLowerCase());
  const content = isText ? (await fs.readFile(file, 'utf8')).slice(0, 512_000) : '';
  const explicit = explicitClassification(content);
  if (explicit === 'internal_process_state') return { classification: explicit, reason: 'explicit traceability_class metadata' };
  if (INTERNAL_NAMES.has(name)) return { classification: 'internal_process_state', reason: `reserved internal filename ${name}` };
  if (INTERNAL_PATHS.some((pattern) => pattern.test(relative))) return { classification: 'internal_process_state', reason: 'reserved internal lifecycle/process path' };
  if (isText && INTERNAL_METADATA.test(content)) return { classification: 'internal_process_state', reason: 'targeted internal metadata field' };
  if (isText && INTERNAL_AUTHORITY_PATH.test(content)) return { classification: 'internal_process_state', reason: 'exact internal authority path or ODN URI' };
  if (explicit === 'client_safe') return { classification: explicit, reason: 'explicit traceability_class metadata with no internal signature' };
  return { classification: 'client_safe', reason: isText ? 'no targeted internal metadata/path signature' : 'non-text artifact outside reserved internal paths' };
}

async function scanShared(target) {
  const sharedRoot = path.join(target, 'artifacts', 'shared');
  const files = await listFiles(sharedRoot);
  const artifacts = [];
  for (const file of files) {
    const classification = await classifySharedFile(sharedRoot, file);
    artifacts.push({
      path: normalizeRelative(path.relative(target, file)),
      shared_relative_path: normalizeRelative(path.relative(sharedRoot, file)),
      sha256: await sha256(file),
      ...classification,
    });
  }
  return { shared_root: normalizeRelative(path.relative(target, sharedRoot)), artifacts };
}

async function leakageGate(target, excluded = new Set()) {
  const scan = await scanShared(target);
  const leaked = scan.artifacts.filter((item) => item.classification === 'internal_process_state' && !excluded.has(item.path));
  const traces = [];
  async function walk(directory) {
    for (const entry of await fs.readdir(directory, { withFileTypes: true })) {
      if (entry.isDirectory()) { if (!TARGET_SCAN_EXCLUDES.has(entry.name)) await walk(path.join(directory, entry.name)); continue; }
      const file = path.join(directory, entry.name);
      if (BINARY_SCAN_EXCLUDE_EXTENSIONS.has(path.extname(file).toLowerCase())) continue;
      if (excluded.has(normalizeRelative(path.relative(target, file)))) continue;
      let buffer;
      try { buffer = await fs.readFile(file); } catch { continue; }
      if (buffer.includes(0)) continue; // binary content sniff for files without a recognized extension
      const content = buffer.toString('utf8');
      if (TARGET_RUNTIME_TOOL_TRACE.test(content) || TARGET_RUNTIME_PROVENANCE_TRACE.test(content) || TARGET_RUNTIME_IDENTITY_FIELD.test(content)) {
        traces.push(normalizeRelative(path.relative(target, file)));
      }
    }
  }
  await walk(target);
  return {
    status: leaked.length || traces.length ? 'FAIL' : 'PASS',
    leaked_paths: leaked.map((item) => ({ path: item.path, reason: item.reason })),
    explicit_ai_trace_paths: traces,
  };
}

function git(target, args, evidence) {
  if (evidence) {
    const key = args.join(' ');
    if (key === 'rev-parse --is-inside-work-tree') return evidence.is_repository === false ? '' : 'true';
    if (key === 'rev-parse --show-toplevel') return evidence.repository_root || target;
    if (key === 'status --porcelain') return evidence.status_porcelain || '';
    if (key === 'rev-parse HEAD') return evidence.head || 'fixture-head';
    if (key === 'branch --show-current') return evidence.branch || 'main';
    if (key === 'config --get remote.origin.url') return evidence.remote || '';
    if (args[0] === 'rev-parse' && args[1] === '--verify' && args[2]?.endsWith('^{commit}')) {
      const commit = args[2].slice(0, -'^{commit}'.length);
      const validCommits = new Set([evidence.head, ...(evidence.valid_commits || [])].filter(Boolean));
      return validCommits.has(commit) ? commit : '';
    }
  }
  try { return execFileSync('git', ['-C', target, ...args], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] }).trim(); }
  catch { return ''; }
}

async function historyScan(target, evidence) {
  if (evidence?.history) {
    const affected = evidence.history.map((item) => ({ commit: item.commit, path: item.path }));
    return { status: affected.length ? 'HISTORY_PURGE_REQUIRED' : 'PASS', history_purge_required: affected.length > 0, affected };
  }
  const isRepo = git(target, ['rev-parse', '--is-inside-work-tree'], evidence) === 'true';
  if (!isRepo) return { status: 'NOT_A_GIT_REPOSITORY', history_purge_required: false, affected: [] };
  const commits = git(target, ['log', '--all', '--format=%H', '--', 'artifacts/shared']).split(/\r?\n/).filter(Boolean);
  const affected = [];
  for (const commit of commits) {
    const paths = git(target, ['ls-tree', '-r', '--name-only', commit, '--', 'artifacts/shared']).split(/\r?\n/).filter(Boolean);
    for (const line of paths) {
      const normalized = line.trim().replaceAll('\\', '/');
      const name = path.posix.basename(normalized);
      let internal = INTERNAL_NAMES.has(name) || INTERNAL_PATHS.some((pattern) => pattern.test(normalized));
      if (!internal && TEXT_EXTENSIONS.has(path.extname(normalized).toLowerCase())) {
        const content = git(target, ['show', `${commit}:${normalized}`]);
        internal = INTERNAL_METADATA.test(content) || INTERNAL_AUTHORITY_PATH.test(content);
      }
      if (internal) affected.push({ commit, path: normalized });
    }
  }
  const unique = [...new Map(affected.map((item) => [`${item.commit}:${item.path}`, item])).values()];
  return { status: unique.length ? 'HISTORY_PURGE_REQUIRED' : 'PASS', history_purge_required: unique.length > 0, affected: unique };
}

function ensureInside(parent, child, label) {
  const relative = path.relative(parent, child);
  if (!relative || relative === '.') return;
  if (relative.startsWith('..') || path.isAbsolute(relative)) throw new Error(`${label} escaped its approved root: ${child}`);
}

async function validateTarget(master, target, evidence) {
  const resolvedMaster = await fs.realpath(master);
  const resolvedTarget = await fs.realpath(target);
  const development = path.join(resolvedMaster, 'development');
  ensureInside(development, resolvedTarget, 'TARGET_PATH');
  if (resolvedTarget === resolvedMaster) throw new Error('the Master Scaffold is never an adoption target');
  const gitRoot = git(resolvedTarget, ['rev-parse', '--show-toplevel'], evidence);
  if (!gitRoot) throw new Error('target is not a Git repository');
  if (path.resolve(gitRoot) !== resolvedTarget) throw new Error('target path must be its own Git repository root');
  return { master: resolvedMaster, target: resolvedTarget };
}

async function targetIdentity(target, evidence) {
  return {
    repository_root: target,
    remote: git(target, ['config', '--get', 'remote.origin.url'], evidence) || 'none',
  };
}

async function createMigrationPlan(master, project, target, options = {}) {
  const evidence = options._git_evidence;
  const validated = await validateTarget(master, target, evidence);
  master = validated.master;
  target = validated.target;
  const locations = authorityPaths(master, project);
  const masterSchema = await readMasterSchema(master);
  const receiptFile = path.join(locations.migration, 'MIGRATION_RECEIPT.json');
  const identity = await targetIdentity(target, evidence);
  const adoption = await readJson(locations.adoption, { project, schema_version: 0, migration_status: 'not_started' });
  const migrationState = await readJson(locations.migrationState, { project, from_schema: 0, to_schema: masterSchema.schema_version, status: 'not_started' });
  const adoptionCurrent = adoption.schema_version === masterSchema.schema_version && adoption.migration_status === 'completed';
  if (await exists(receiptFile)) {
    const receipt = await readJson(receiptFile, {});
    if (receipt.status === 'completed' && adoptionCurrent) {
      if (JSON.stringify(receipt.target_identity) !== JSON.stringify(identity)) throw new Error('PROJECT_RECEIPT_COLLISION: project receipt belongs to a different target repository');
      const leakage = await leakageGate(target);
      if (leakage.status !== 'PASS') throw new Error(`IDEMPOTENT_RECHECK_FAILED: internal process state was reintroduced: ${JSON.stringify(leakage.leaked_paths)}`);
      return {
        result: 'already_completed', status: 'already_completed', idempotent: true, migration_required: false,
        master_schema_version: masterSchema.schema_version, project_adoption: adoption, migration_state: migrationState,
        leakage_gate: 'PASS', receipt,
      };
    }
  }
  const sharedRoot = path.join(target, 'artifacts', 'shared');
  if (!(await exists(sharedRoot))) throw new Error('target artifacts/shared is missing');
  const scan = await scanShared(target);
  const internal = scan.artifacts.filter((item) => item.classification === 'internal_process_state');
  const excluded = new Set(internal.map((item) => item.path));
  const projectedLeakage = await leakageGate(target, excluded);
  const history = await historyScan(target, evidence);
  const dirty = git(target, ['status', '--porcelain'], evidence);
  const gitRootNames = ['AGENTS.md', 'CLAUDE.md', 'GEMINI.md', '.codex', '.claude', '.agents'];
  const legacyPaths = [];
  for (const name of gitRootNames) if (await exists(path.join(target, name))) legacyPaths.push(name);
  const head = git(target, ['rev-parse', 'HEAD'], evidence) || 'unborn';
  const reportMaterial = scan.artifacts.map((item) => `${item.path}|${item.classification}|${item.sha256}`).join(';');
  const reportId = sha256Text(`${target}|${project}|${head}|${reportMaterial}|odn-traceability-v2`).slice(0, 16);
  let status = adoption.schema_version > 0 ? 'ready_for_schema_adoption_apply' : 'ready_for_first_adoption_apply';
  if (['in_progress', 'failed', 'rollback_required'].includes(migrationState.status) || ['in_progress', 'failed', 'rollback_required'].includes(adoption.migration_status)) status = 'ready_for_migration_recovery_apply';
  if (dirty) status = 'blocked_dirty_target';
  else if (legacyPaths.length) status = 'blocked_legacy_scaffold_copy';
  else if (projectedLeakage.status !== 'PASS') status = 'blocked_projected_client_share_leakage';
  return {
    result: 'dry_run',
    status,
    report_id: reportId,
    project,
    master_schema_version: masterSchema.schema_version,
    project_adoption: adoption,
    migration_state: migrationState,
    migration_required: true,
    target,
    target_identity: identity,
    target_head: head,
    target_dirty: Boolean(dirty),
    legacy_scaffold_paths: legacyPaths,
    classification: scan,
    counts: {
      scanned: scan.artifacts.length,
      client_safe: scan.artifacts.filter((item) => item.classification === 'client_safe').length,
      internal_process_state: internal.length,
    },
    projected_leakage_gate: projectedLeakage,
    history,
    mutation: 'none',
    apply_requirement: '--apply --report-id <exact-id> --remove-internal-originals',
    history_rewrite: 'never automatic',
  };
}

async function copyVerified(source, destination, expectedHash) {
  await fs.mkdir(path.dirname(destination), { recursive: true });
  if (await exists(destination)) {
    if (await sha256(destination) === expectedHash) return;
    // A failed migration may have already redacted a verified local archive. Rebuild the
    // exact source copy under the migration lock, then redact it again with a new receipt.
    await fs.rm(destination);
  }
  const temp = `${destination}.${process.pid}.${Date.now()}.tmp`;
  await fs.copyFile(source, temp, constants.COPYFILE_EXCL);
  if (await sha256(temp) !== expectedHash) {
    await fs.rm(temp, { force: true });
    throw new Error(`COPY_VERIFICATION_FAILED: ${source}`);
  }
  try { await fs.rename(temp, destination); }
  finally { await fs.rm(temp, { force: true }); }
}

async function redactLegacyIdentityMetadata(archiveRoot) {
  const receipt = [];
  for (const file of await listFiles(archiveRoot)) {
    if (!TEXT_EXTENSIONS.has(path.extname(file).toLowerCase())) continue;
    const content = await fs.readFile(file, 'utf8');
    const redacted = content.replace(IDENTITY_METADATA_LINE_PATTERN, '');
    const beforeHash = sha256Text(content);
    const afterHash = sha256Text(redacted);
    if (content !== redacted) await writeFileAtomic(file, redacted);
    receipt.push({
      archive_path: normalizeRelative(path.relative(archiveRoot, file)),
      source_sha256: beforeHash,
      archived_sha256: afterHash,
      identity_metadata_redacted: content !== redacted,
    });
  }
  return receipt;
}

function extractMetadataReferences(content, fields) {
  const escaped = fields.join('|');
  const expression = new RegExp(`^(?:\\s*[-*]\\s*)?(?:["']?)(${escaped})(?:["']?)\\s*[:=]\\s*[\\x60"']?([^\\x60"'\\r\\n]+)`, 'gim');
  return [...content.matchAll(expression)].map((match) => ({ field: match[1].toLowerCase(), reference: match[2].trim().replaceAll('\\', '/') }));
}

function sharedRelativeFromReference(reference) {
  const normalized = reference.replace(/^\.\//, '');
  const match = normalized.match(/^(?:development\/[^/]+\/)?artifacts\/shared\/(.+)$/i);
  return match ? match[1].replace(/[),.;]+$/, '') : '';
}

async function verifyMigration(master, project, target, scan, batchId) {
  const locations = authorityPaths(master, project);
  const archiveRoot = path.join(locations.migration, 'migrated-shared');
  const internal = scan.artifacts.filter((item) => item.classification === 'internal_process_state');
  const sourceHashReceipt = await readJson(path.join(locations.migrationEvidence, 'SOURCE_HASH_VERIFICATION.json'), { artifacts: [] });
  const redactionReceipt = await readJson(path.join(locations.migrationEvidence, 'ARCHIVE_REDACTION_RECEIPT.json'), { artifacts: [] });
  const sourceHashes = new Map((sourceHashReceipt.artifacts || []).map((item) => [item.shared_relative_path, item]));
  const archivedHashes = new Map((redactionReceipt.artifacts || []).map((item) => [item.archive_path, item]));
  const bySharedRelative = new Map(scan.artifacts.map((item) => [item.shared_relative_path.toLowerCase(), item]));
  const referenceFindings = [];
  let copyPass = true;
  let graphifyPass = true;
  for (const artifact of internal) {
    const destination = path.join(archiveRoot, ...artifact.shared_relative_path.split('/'));
    const sourceHash = sourceHashes.get(artifact.shared_relative_path);
    const archivedHash = archivedHashes.get(artifact.shared_relative_path);
    if (!(await exists(destination)) || sourceHash?.sha256 !== artifact.sha256 || archivedHash?.source_sha256 !== artifact.sha256 || await sha256(destination) !== archivedHash.archived_sha256) copyPass = false;
    if (/(?:^|\/)(?:graphify-out|\.graphify)(?:\/|$)/i.test(artifact.shared_relative_path)) graphifyPass = false;
    if (!TEXT_EXTENSIONS.has(path.extname(destination).toLowerCase()) || !(await exists(destination))) continue;
    const content = await fs.readFile(destination, 'utf8');
    const references = extractMetadataReferences(content, ['internal_handoff', 'handoff_path', 'lifecycle_reference', 'shared_context_reference']);
    for (const item of references) {
      const { field, reference } = item;
      const sharedRelative = sharedRelativeFromReference(reference);
      if (sharedRelative) {
        const referenced = bySharedRelative.get(sharedRelative.toLowerCase());
        if (!referenced) { referenceFindings.push({ source: artifact.path, field, reference, reason: 'unknown_shared_context_reference' }); continue; }
        const resolved = referenced.classification === 'internal_process_state'
          ? path.join(archiveRoot, ...referenced.shared_relative_path.split('/'))
          : path.join(target, 'artifacts', 'shared', ...referenced.shared_relative_path.split('/'));
        if (!(await exists(resolved))) referenceFindings.push({ source: artifact.path, field, reference, reason: 'missing_shared_context_reference' });
      } else if (/^artifacts\/(?:improvement|test|release|operations)\//i.test(reference)) {
        if (!(await exists(path.join(master, ...reference.split('/'))))) referenceFindings.push({ source: artifact.path, field, reference, reason: 'missing_lifecycle_reference' });
      }
    }
  }
  let lookupPass = false;
  let statePass = false;
  try {
    const batch = await resolveBatchById(locations, batchId);
    lookupPass = batch.batch_id === batchId;
    const state = await readJson(locations.state, { active_batches: {} });
    statePass = state.active_batches?.['scaffold:schema-adoption']?.batch_id === batchId;
  } catch { lookupPass = false; statePass = false; }
  const lifecycleFiles = [
    path.join(master, 'guardrails', 'development', 'ODN_TRACEABILITY_POLICY.md'),
    path.join(master, 'guardrails', 'development', 'SHARED_CONTEXT_POLICY.md'),
    path.join(master, 'workflows', 'ai_contributor_lifecycle.md'),
  ];
  const lifecyclePass = (await Promise.all(lifecycleFiles.map((file) => exists(file)))).every(Boolean) && referenceFindings.every((item) => item.field !== 'lifecycle_reference');
  const handoffPass = await exists(locations.handoffs) && referenceFindings.every((item) => !['internal_handoff', 'handoff_path'].includes(item.field));
  const sharedReferencePass = referenceFindings.length === 0;
  const projectedLeakage = await leakageGate(target, new Set(internal.map((item) => item.path)));
  const identity = await identityGate(master);
  const checks = {
    master_scaffold_copy_exists: copyPass ? 'PASS' : 'FAIL',
    odn_lookup: lookupPass ? 'PASS' : 'FAIL',
    batch_state_resolution: statePass ? 'PASS' : 'FAIL',
    internal_handoff: handoffPass ? 'PASS' : 'FAIL',
    lifecycle_integration: lifecyclePass ? 'PASS' : 'FAIL',
    graphify_boundary: graphifyPass ? 'PASS' : 'FAIL',
    shared_context_references_updated: sharedReferencePass ? 'PASS' : 'FAIL',
    leakage_gate: projectedLeakage.status,
    identity_free_internal_state: identity.status,
  };
  return { status: Object.values(checks).every((value) => value === 'PASS') ? 'PASS' : 'FAIL', checks, reference_findings: referenceFindings, identity_findings: identity.prohibited_identity_findings };
}

async function updatePreventionRules(target) {
  const ignoreFile = path.join(target, '.gitignore');
  let content = (await exists(ignoreFile)) ? await fs.readFile(ignoreFile, 'utf8') : '';
  const block = `${PREVENTION_START}\n${PREVENTION_RULES.join('\n')}\n${PREVENTION_END}`;
  const escape = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const expression = new RegExp(`${escape(PREVENTION_START)}[\\s\\S]*?${escape(PREVENTION_END)}`, 'm');
  content = expression.test(content) ? content.replace(expression, block) : `${content.trimEnd()}${content.trim() ? '\n\n' : ''}${block}\n`;
  await writeFileAtomic(ignoreFile, content);
}

async function removeEmptyInternalDirectories(target, scan) {
  const sharedRoot = await fs.realpath(path.join(target, 'artifacts', 'shared'));
  const directories = new Set();
  for (const artifact of scan.artifacts.filter((item) => item.classification === 'internal_process_state')) {
    let directory = path.dirname(path.join(target, ...artifact.path.split('/')));
    while (directory.startsWith(sharedRoot) && directory !== sharedRoot) { directories.add(directory); directory = path.dirname(directory); }
  }
  for (const directory of [...directories].sort((a, b) => b.length - a.length)) {
    ensureInside(sharedRoot, directory, 'EMPTY_INTERNAL_DIRECTORY');
    try { await fs.rmdir(directory); } catch (error) { if (!['ENOTEMPTY', 'ENOENT'].includes(error.code)) throw error; }
  }
}

async function migrateShared(master, project, target, options) {
  const plan = await createMigrationPlan(master, project, target, options);
  if (!options.apply || plan.status === 'already_completed') return plan;
  if (options.report_id !== plan.report_id) throw new Error(`REPORT_ID_MISMATCH: apply requires ${plan.report_id}`);
  if (!options.remove_internal_originals) throw new Error('EXPLICIT_REMOVAL_REQUIRED: add --remove-internal-originals only after reviewing the dry-run');
  if (!['ready_for_first_adoption_apply', 'ready_for_schema_adoption_apply', 'ready_for_migration_recovery_apply'].includes(plan.status)) throw new Error(`MIGRATION_BLOCKED: ${plan.status}`);
  master = await fs.realpath(master);
  target = await fs.realpath(target);
  const locations = await bootstrap(master, project);
  const masterSchema = await readMasterSchema(master);
  return withMigrationLock(locations, masterSchema.schema_version, async () => {
    const rechecked = await createMigrationPlan(master, project, target, options);
    if (rechecked.status === 'already_completed') return rechecked;
    if (rechecked.report_id !== options.report_id) throw new Error(`MIGRATION_INPUT_CHANGED: rerun dry-run and use report id ${rechecked.report_id}`);
    const startedAt = new Date().toISOString();
    await writeJsonAtomic(locations.migrationState, {
      project,
      from_schema: rechecked.project_adoption.schema_version || 0,
      to_schema: masterSchema.schema_version,
      status: 'in_progress',
      report_id: rechecked.report_id,
      started_at: startedAt,
      recovery_of: rechecked.migration_state.status === 'not_started' ? null : rechecked.migration_state.status,
    });
    await writeJsonAtomic(locations.adoption, {
      project,
      schema_version: rechecked.project_adoption.schema_version || 0,
      migration_status: 'in_progress',
      updated_at: startedAt,
    });
    try {
      const allocation = await allocate(master, project, { component: 'scaffold', scope: 'schema-adoption', objective: 'Move internal target shared state into Master Scaffold authority' });
      const archiveRoot = path.join(locations.migration, 'migrated-shared');
      const internal = rechecked.classification.artifacts.filter((item) => item.classification === 'internal_process_state');
      for (const artifact of internal) {
        const source = path.join(target, ...artifact.path.split('/'));
        const destination = path.join(archiveRoot, ...artifact.shared_relative_path.split('/'));
        await copyVerified(source, destination, artifact.sha256);
      }
      await writeJsonAtomic(path.join(locations.migrationEvidence, 'SOURCE_HASH_VERIFICATION.json'), {
        schema_version: masterSchema.schema_version,
        project,
        report_id: rechecked.report_id,
        verified_at: new Date().toISOString(),
        artifacts: internal.map((item) => ({ shared_relative_path: item.shared_relative_path, sha256: item.sha256 })),
      });
      const redactionReceipt = await redactLegacyIdentityMetadata(archiveRoot);
      await writeJsonAtomic(path.join(locations.migrationEvidence, 'ARCHIVE_REDACTION_RECEIPT.json'), {
        schema_version: masterSchema.schema_version,
        project,
        report_id: rechecked.report_id,
        redacted_at: new Date().toISOString(),
        artifacts: redactionReceipt,
      });
      await writeJsonAtomic(path.join(locations.migrationEvidence, 'CLASSIFICATION_MANIFEST.json'), {
        schema_version: masterSchema.schema_version,
        project,
        report_id: rechecked.report_id,
        created_at: new Date().toISOString(),
        artifacts: rechecked.classification.artifacts,
      });
      const verification = await verifyMigration(master, project, target, rechecked.classification, allocation.batch_id);
      await writeJsonAtomic(path.join(locations.migrationEvidence, 'PRE_REMOVAL_VERIFICATION.json'), verification);
      if (verification.status !== 'PASS') throw new Error(`MIGRATION_VERIFICATION_FAILED: ${JSON.stringify(verification)}`);

      const sharedRoot = await fs.realpath(path.join(target, 'artifacts', 'shared'));
      for (const artifact of internal) {
        const source = await fs.realpath(path.join(target, ...artifact.path.split('/')));
        ensureInside(sharedRoot, source, 'INTERNAL_SOURCE_REMOVAL');
        await fs.rm(source);
      }
      await removeEmptyInternalDirectories(target, rechecked.classification);
      await updatePreventionRules(target);
      const leakage = await leakageGate(target);
      if (leakage.status !== 'PASS') throw new Error(`POST_REMOVAL_LEAKAGE_GATE_FAILED: ${JSON.stringify(leakage.leaked_paths)}`);
      const completedAt = new Date().toISOString();
      const receipt = {
        schema_version: masterSchema.schema_version,
        project,
        status: 'completed',
        report_id: rechecked.report_id,
        target_identity: rechecked.target_identity,
        target_head_before_migration: rechecked.target_head,
        batch_id: allocation.batch_id,
        completed_at: completedAt,
        migrated_internal_paths: internal.map((item) => item.path),
        preserved_client_safe_paths: rechecked.classification.artifacts.filter((item) => item.classification === 'client_safe').map((item) => item.path),
        checks: verification.checks,
        history: rechecked.history,
        history_rewritten: false,
      };
      await writeJsonAtomic(path.join(locations.migration, 'MIGRATION_RECEIPT.json'), receipt);
      await writeJsonAtomic(locations.adoption, { project, schema_version: masterSchema.schema_version, migration_status: 'completed', updated_at: completedAt });
      await writeJsonAtomic(locations.migrationState, {
        project, from_schema: rechecked.project_adoption.schema_version || 0, to_schema: masterSchema.schema_version,
        status: 'completed', report_id: rechecked.report_id, started_at: startedAt, completed_at: completedAt,
      });
      return { result: 'completed', status: 'completed', idempotent: true, receipt };
    } catch (error) {
      await writeJsonAtomic(locations.migrationState, {
        project, from_schema: rechecked.project_adoption.schema_version || 0, to_schema: masterSchema.schema_version,
        status: 'failed', report_id: rechecked.report_id, failed_at: new Date().toISOString(), failure: error.message,
      });
      await writeJsonAtomic(locations.adoption, { project, schema_version: rechecked.project_adoption.schema_version || 0, migration_status: 'failed', updated_at: new Date().toISOString() });
      throw error;
    }
  });
}

function help() {
  return {
    usage: [
      'odn-traceability bootstrap --project <name> [--master <path>]',
      'odn-traceability allocate --project <name> --component <name> --scope <scope> [--objective <text>]',
      'odn-traceability update --project <name> --batch odn-xxxx [--acceptance <csv>] [--files <csv>] [--symbols <csv>] [--evidence <csv>] [--validation pass] [--commit <hash> --target <path>] [--state completed]',
      'odn-traceability resolve --project <name> --component <name> --scope <scope> [--limit 1..3]',
      'odn-traceability validate-provenance --source-file <path> --batch <odn-id> [--commit-message-file <path>]',
      'odn-traceability migrate-shared --project <name> --target <path>',
      'odn-traceability migrate-shared --project <name> --target <path> --apply --report-id <id> --remove-internal-originals',
      'odn-traceability share-gate --target <path>',
      'odn-traceability history-scan --target <path>',
      'odn-traceability identity-gate [--master <path>]',
    ],
  };
}

async function main() {
  const { command, options } = parseArgs(process.argv.slice(2));
  if (options.git_evidence_file) options._git_evidence = JSON.parse(await fs.readFile(path.resolve(options.git_evidence_file), 'utf8'));
  const master = path.resolve(options.master || defaultMaster);
  let result;
  if (command === 'help') result = help();
  else if (command === 'bootstrap') result = { result: 'ready', authority: (await bootstrap(master, safeProject(options.project))).root };
  else if (command === 'allocate') result = await allocate(master, safeProject(options.project), options);
  else if (command === 'update') result = await updateBatch(master, safeProject(options.project), options);
  else if (command === 'resolve') result = await resolve(master, safeProject(options.project), options);
  else if (command === 'validate-provenance') result = await validateProvenance(options);
  else if (command === 'migrate-shared') {
    if (!options.target) throw new Error('--target is required');
    result = await migrateShared(master, safeProject(options.project), path.resolve(options.target), options);
  } else if (command === 'share-gate') {
    if (!options.target) throw new Error('--target is required');
    result = await leakageGate(path.resolve(options.target));
  } else if (command === 'history-scan') {
    if (!options.target) throw new Error('--target is required');
    result = await historyScan(path.resolve(options.target), options._git_evidence);
  } else if (command === 'identity-gate') {
    result = await identityGate(master);
  } else throw new Error(`Unknown command: ${command}`);
  process.stdout.write(`${JSON.stringify(result, null, 2)}\n`);
  if (result.status === 'FAIL') process.exitCode = 2;
}

const invokedDirectly = process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url);
if (invokedDirectly) {
  main().catch((error) => {
    process.stderr.write(`ODN_TRACEABILITY_ERROR: ${error.message}\n`);
    process.exitCode = 1;
  });
}

export {
  allocate,
  bootstrap,
  createMigrationPlan,
  historyScan,
  identityGate,
  leakageGate,
  migrateShared,
  resolve,
  safeProject,
  updateBatch,
  validateProvenance,
};
