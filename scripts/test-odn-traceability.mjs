#!/usr/bin/env node

import * as fs from 'node:fs/promises';
import { execFileSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  allocate,
  historyScan,
  identityGate,
  leakageGate,
  migrateShared,
  resolve,
  updateBatch,
  validateProvenance,
} from './odn-traceability.mjs';

const results = [];
const repositoryRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
function assert(condition, message) { if (!condition) throw new Error(`ASSERTION_FAILED: ${message}`); }
async function write(file, content) { await fs.mkdir(path.dirname(file), { recursive: true }); await fs.writeFile(file, content, 'utf8'); }

const temporaryBase = await fs.mkdtemp(path.join(os.tmpdir(), 'odn-traceability-v2-'));
try {
  const master = path.join(temporaryBase, 'master');
  const target = path.join(master, 'development', 'fixture-project');
  const evidence = {
    is_repository: true,
    repository_root: target,
    status_porcelain: '',
    head: '0123456789abcdef',
    branch: 'main',
    remote: 'fixture://client/project',
    history: [
      { commit: 'legacy-commit', path: 'artifacts/shared/ACTIVE_CONTEXT.md' },
      { commit: 'legacy-commit', path: 'artifacts/shared/handoffs/auth-login.md' },
    ],
  };
  await fs.mkdir(target, { recursive: true });
  await write(path.join(master, 'SCAFFOLD_VERSION.md'), '- version: `9.9.9-fixture`\n');
  execFileSync('git', ['init', '-q'], { cwd: master });
  execFileSync('git', ['config', 'user.email', 'fixture@example.invalid'], { cwd: master });
  execFileSync('git', ['config', 'user.name', 'ODN Fixture'], { cwd: master });
  execFileSync('git', ['add', 'SCAFFOLD_VERSION.md'], { cwd: master });
  execFileSync('git', ['commit', '-qm', 'fixture master'], { cwd: master });
  await write(path.join(master, 'guardrails', 'development', 'ODN_TRACEABILITY_POLICY.md'), 'fixture policy\n');
  await write(path.join(master, 'guardrails', 'development', 'SHARED_CONTEXT_POLICY.md'), 'artifacts/traceability-local/[project]/\n');
  await write(path.join(master, 'workflows', 'ai_contributor_lifecycle.md'), 'fixture lifecycle\n');
  await write(path.join(target, 'artifacts', 'shared', 'PROJECT_STATE.md'), [
    '# Project State',
    '- traceability_class: `client_safe`',
    '- note: `The business model uses an agent provider for batch lifecycle handoff services.`',
    '',
  ].join('\n'));
  await write(path.join(target, 'artifacts', 'shared', 'unsafe-explicit-client-safe.md'), [
    '# Incorrect Explicit Classification',
    '- traceability_class: `client_safe`',
    '- resume_safe: `yes`',
    '',
  ].join('\n'));
  await write(path.join(target, 'artifacts', 'shared', 'ACTIVE_CONTEXT.md'), [
    '# Active Context',
    '- traceability_class: `internal_process_state`',
    '- resume_safe: `yes`',
    '',
  ].join('\n'));
  await write(path.join(target, 'artifacts', 'shared', 'handoffs', 'auth-login.md'), [
    '# Internal Handoff',
    '- traceability_class: `internal_process_state`',
    '- runtime: `legacy-tool`',
    '- shared_context_reference: `artifacts/shared/PROJECT_STATE.md`',
    '',
  ].join('\n'));

  const first = await allocate(master, 'fixture-project', { component: 'auth', scope: 'login', objective: 'Trace login change' });
  assert(first.result === 'allocated' && first.batch_id === 'odn-0001', 'first allocation must reserve odn-0001');
  const masterSchema = JSON.parse(await fs.readFile(path.join(master, 'artifacts', 'traceability', 'MASTER_SCAFFOLD_SCHEMA.json'), 'utf8'));
  assert(masterSchema.schema_version === 4, 'bootstrap must establish Master Scaffold schema authority');
  assert(await fs.stat(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'BATCH_STATE.json')), 'per-project ODN state must live under the local-only authority root');
  assert(!(await fs.stat(path.join(master, 'artifacts', 'traceability', 'fixture-project')).catch(() => null)), 'per-project state must not be written under the Git-carried traceability root');
  assert((await identityGate(master)).status === 'PASS', 'new Master Scaffold continuity state must be identity-free');

  const identityProbe = path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'IDENTITY_PROBE.md');
  await write(identityProbe, '# Probe\n- model: `gpt-5`\n');
  const identityDirty = await identityGate(master);
  assert(identityDirty.status === 'FAIL' && identityDirty.prohibited_identity_findings.some((item) => item.path.includes('traceability-local')), 'identity-gate must police the Git-ignored local-only per-project store, not just the Git-carried schema authority');
  await fs.rm(identityProbe, { force: true });
  assert((await identityGate(master)).status === 'PASS', 'identity-gate must pass again once the offending local-only file is removed');
  results.push('identity-gate covers the local-only per-project store distinctly from the target leakage gate: PASS');
  const resumed = await allocate(master, 'fixture-project', { component: 'auth', scope: 'login' });
  assert(resumed.result === 'resumed' && resumed.batch_id === first.batch_id, 'same component:scope must resume its active batch');
  const simultaneous = await Promise.all([
    allocate(master, 'fixture-project', { component: 'billing', scope: 'invoice' }),
    allocate(master, 'fixture-project', { component: 'catalog', scope: 'search' }),
    allocate(master, 'fixture-project', { component: 'profile', scope: 'settings' }),
  ]);
  assert(new Set(simultaneous.map((item) => item.batch_id)).size === 3, 'concurrent different keys must receive collision-free IDs');
  results.push('atomic/collision-safe allocation, same-key resume, and multi-active keys: PASS');

  const resolved = await resolve(master, 'fixture-project', { component: 'auth', scope: 'login', limit: '3' });
  assert(resolved.count === 1 && resolved.graphify_content_included === false, 'selective context must resolve at most three records without Graphify content');
  let overLimitFailed = false;
  try { await resolve(master, 'fixture-project', { component: 'auth', scope: 'login', limit: '4' }); } catch { overLimitFailed = true; }
  assert(overLimitFailed, 'context limit above three must fail');
  results.push('selective <=3 context and Graphify boundary: PASS');

  const completed = await updateBatch(master, 'fixture-project', {
    batch: first.batch_id,
    acceptance: 'Login behavior remains traceable',
    files: 'src/auth/login.js',
    symbols: 'authenticate',
    evidence: 'focused fixture validation',
    validation: 'pass',
    commit: evidence.head,
    target,
    state: 'completed',
    _git_evidence: evidence,
  });
  assert(completed.state === 'completed' && completed.validation_status === 'pass', 'batch completion must require acceptance, validation pass, and verified Git provenance');
  const codeMap = JSON.parse(await fs.readFile(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'CODE_MAP.json'), 'utf8'));
  assert(codeMap.entries.some((item) => item.file === 'src/auth/login.js' && item.batches.includes(first.batch_id)), 'batch update must maintain the source-to-batch lookup map');
  results.push('batch lifecycle completion and verified Git provenance map: PASS');

  const sourceFile = path.join(temporaryBase, 'source.js');
  const commitMessage = path.join(temporaryBase, 'commit-message.txt');
  await write(sourceFile, `// @batch ${first.batch_id}\nexport const value = true;\n`);
  await write(commitMessage, `Implement fixture\n\nBatch: ${first.batch_id}\n`);
  const provenance = await validateProvenance({ source_file: sourceFile, batch: first.batch_id, commit_message_file: commitMessage });
  assert(provenance.status === 'PASS', 'source marker and Batch trailer must validate');
  results.push('source marker and Batch trailer: PASS');

  const leakage = await leakageGate(target);
  assert(leakage.status === 'FAIL' && leakage.leaked_paths.some((item) => item.path.endsWith('ACTIVE_CONTEXT.md')), 'target leakage gate must detect internal metadata paths');
  assert(!leakage.leaked_paths.some((item) => item.path.endsWith('PROJECT_STATE.md')), 'ordinary business words must not trigger leakage');
  assert(leakage.leaked_paths.some((item) => item.path.endsWith('unsafe-explicit-client-safe.md')), 'client-safe metadata must not override a targeted internal field');
  results.push('targeted leakage detection and ordinary-word false-positive guard: PASS');

  const explicitTraceTarget = path.join(temporaryBase, 'explicit-trace-target');
  await write(path.join(explicitTraceTarget, 'artifacts', 'shared', 'PROJECT_STATE.md'), '# Client-safe facts\n');
  await write(path.join(explicitTraceTarget, 'README.md'), '# Fixture Project\n\nBuilt with Claude Code and the Codex CLI.\n');
  const explicitTraceScan = await leakageGate(explicitTraceTarget);
  assert(explicitTraceScan.status === 'FAIL' && explicitTraceScan.explicit_ai_trace_paths.some((item) => item.endsWith('README.md')), 'the whole-tree scanner must fail a target that carries an explicit AI/runtime/process trace term outside artifacts/shared');
  results.push('explicit AI-trace target fails the whole-tree share gate: PASS');

  const cleanTarget = path.join(temporaryBase, 'clean-target');
  await write(path.join(cleanTarget, 'artifacts', 'shared', 'PROJECT_STATE.md'), '# Client-safe facts\n- traceability_class: `client_safe`\n');
  await write(path.join(cleanTarget, 'README.md'), '# Fixture Project\n\nOrdinary product documentation with no internal process trace.\n');
  await write(path.join(cleanTarget, 'src', 'index.js'), '// @batch odn-0001\nexport const value = true;\n');
  const cleanScan = await leakageGate(cleanTarget);
  assert(cleanScan.status === 'PASS' && cleanScan.leaked_paths.length === 0 && cleanScan.explicit_ai_trace_paths.length === 0, 'a client-safe target with only an opaque @batch marker must pass the whole-tree share gate cleanly');
  results.push('clean target passes the whole-tree share gate: PASS');

  const dryRun = await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence });
  assert(dryRun.status === 'ready_for_first_adoption_apply', 'clean first adoption must produce a ready dry-run');
  assert(dryRun.counts.scanned === 4 && dryRun.counts.internal_process_state === 3 && dryRun.counts.client_safe === 1, 'dry-run must classify every shared artifact exactly once');
  assert(dryRun.projected_leakage_gate.status === 'PASS', 'projected target share must pass after exact internal exclusions');
  assert(await fs.stat(path.join(target, 'artifacts', 'shared', 'ACTIVE_CONTEXT.md')), 'dry-run must not remove internal originals');
  assert(!(await fs.stat(path.join(master, 'artifacts', 'traceability', 'fixture-project', 'migration-evidence', 'CLASSIFICATION_MANIFEST.json')).catch(() => null)), 'dry-run must not create a migration manifest');
  let guardedApplyFailed = false;
  try {
    await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence, apply: true, report_id: dryRun.report_id });
  } catch (error) { guardedApplyFailed = /EXPLICIT_REMOVAL_REQUIRED/.test(error.message); }
  assert(guardedApplyFailed, 'apply without explicit internal-original removal switch must fail before mutation');
  assert(await fs.stat(path.join(target, 'artifacts', 'shared', 'ACTIVE_CONTEXT.md')), 'guarded apply failure must preserve internal originals');
  let wrongReportIdFailed = false;
  try {
    await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence, apply: true, report_id: 'not-the-real-report-id', remove_internal_originals: true });
  } catch (error) { wrongReportIdFailed = /REPORT_ID_MISMATCH/.test(error.message); }
  assert(wrongReportIdFailed, 'apply with a stale or incorrect report id must fail before mutation');
  assert(await fs.stat(path.join(target, 'artifacts', 'shared', 'ACTIVE_CONTEXT.md')), 'a report-id mismatch must preserve internal originals');
  results.push('first-adoption dry-run, full classification, exact report, and removal guard: PASS');

  const history = await historyScan(target, evidence);
  assert(history.status === 'HISTORY_PURGE_REQUIRED' && history.affected.length === 2, 'history leakage must be reported without a rewrite operation');
  results.push('Git history reporting without rewrite: PASS');

  const applied = await migrateShared(master, 'fixture-project', target, {
    _git_evidence: evidence,
    apply: true,
    report_id: dryRun.report_id,
    remove_internal_originals: true,
  });
  assert(applied.status === 'completed', 'fixture apply must complete after all checks pass');
  assert(Object.values(applied.receipt.checks).every((value) => value === 'PASS'), 'all eight migration checks must pass before removal');
  assert(await fs.stat(path.join(target, 'artifacts', 'shared', 'PROJECT_STATE.md')), 'client-safe artifact must remain in target');
  assert(!(await fs.stat(path.join(target, 'artifacts', 'shared', 'ACTIVE_CONTEXT.md')).catch(() => null)), 'verified internal artifact must be removed from target');
  const migratedCopyPath = path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'migration', 'migrated-shared', 'ACTIVE_CONTEXT.md');
  assert(await fs.stat(migratedCopyPath), 'verified Master Scaffold local-only copy must exist');
  const migratedCopyHash = createHash('sha256').update(await fs.readFile(migratedCopyPath)).digest('hex');
  const expectedHash = dryRun.classification.artifacts.find((item) => item.path.endsWith('ACTIVE_CONTEXT.md')).sha256;
  assert(migratedCopyHash === expectedHash, 'the migrated local-only copy must hash-match the exact artifact recorded in the dry-run classification');
  const migratedHandoff = await fs.readFile(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'migration', 'migrated-shared', 'handoffs', 'auth-login.md'), 'utf8');
  assert(!/^- runtime:/im.test(migratedHandoff), 'legacy identity metadata must be redacted only after the source hash is recorded');
  const sourceHashReceipt = JSON.parse(await fs.readFile(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'migration-evidence', 'SOURCE_HASH_VERIFICATION.json'), 'utf8'));
  assert(sourceHashReceipt.artifacts.some((item) => item.shared_relative_path === 'handoffs/auth-login.md'), 'source hash verification must preserve evidence for a redacted archive');
  const adoption = JSON.parse(await fs.readFile(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'PROJECT_ADOPTION.json'), 'utf8'));
  const migrationState = JSON.parse(await fs.readFile(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'MIGRATION_STATE.json'), 'utf8'));
  assert(adoption.schema_version === 4 && adoption.migration_status === 'completed' && migrationState.status === 'completed', 'completion must record current schema adoption and migration state');
  const repeat = await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence });
  assert(repeat.status === 'already_completed' && repeat.idempotent && repeat.leakage_gate === 'PASS', 'migration rerun must be idempotent and recheck leakage');
  results.push('copy/verify/remove order, eight checks, client-safe preservation, prevention, adoption state, and idempotency: PASS');

  await write(path.join(master, 'artifacts', 'traceability', 'MASTER_SCAFFOLD_SCHEMA.json'), JSON.stringify({ schema_version: 5, authority: 'master-scaffold-odn', migration_contract: 'one-time-per-project-per-schema-version' }, null, 2));
  const schemaUpgrade = await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence });
  assert(schemaUpgrade.status === 'ready_for_schema_adoption_apply' && schemaUpgrade.migration_required, 'new schema must require a new migration instead of accepting an old receipt');
  await write(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'MIGRATION_STATE.json'), JSON.stringify({ project: 'fixture-project', from_schema: 4, to_schema: 5, status: 'failed' }, null, 2));
  await write(path.join(master, 'artifacts', 'traceability-local', 'fixture-project', 'PROJECT_ADOPTION.json'), JSON.stringify({ project: 'fixture-project', schema_version: 4, migration_status: 'failed' }, null, 2));
  const recovery = await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence });
  assert(recovery.status === 'ready_for_migration_recovery_apply', 'failed migration must enter explicit recovery path instead of starting an unrelated migration');
  const lockPath = path.join(master, 'artifacts', 'traceability-local', 'fixture-project', '.migration-v5.lock');
  await write(lockPath, '{"status":"in_progress"}\n');
  let lockBlocked = false;
  try {
    await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence, apply: true, report_id: recovery.report_id, remove_internal_originals: true });
  } catch (error) { lockBlocked = /MIGRATION_LOCKED/.test(error.message); }
  assert(lockBlocked, 'schema migration lock must prevent concurrent migration');
  await fs.rm(lockPath, { force: true });
  const recovered = await migrateShared(master, 'fixture-project', target, { _git_evidence: evidence, apply: true, report_id: recovery.report_id, remove_internal_originals: true });
  assert(recovered.status === 'completed', 'recovery apply must complete without duplicate state');
  results.push('schema mismatch, failed-state recovery, and project-schema migration lock: PASS');

  if (process.platform === 'win32') {
    const updateTarget = path.join(master, 'development', 'update-fixture');
    await write(path.join(updateTarget, 'artifacts', 'shared', 'PROJECT_STATE.md'), '# Client-safe facts\n');
    await write(path.join(updateTarget, 'artifacts', 'shared', 'ACTIVE_CONTEXT.md'), '# Internal\n- resume_safe: `yes`\n');
    execFileSync('git', ['init', '-q'], { cwd: updateTarget });
    execFileSync('git', ['config', 'user.email', 'fixture@example.invalid'], { cwd: updateTarget });
    execFileSync('git', ['config', 'user.name', 'ODN Fixture'], { cwd: updateTarget });
    execFileSync('git', ['add', '.'], { cwd: updateTarget });
    execFileSync('git', ['commit', '-qm', 'fixture target'], { cwd: updateTarget });
    const updateScript = path.join(repositoryRoot, 'scripts', 'update-scaffold-project.ps1');
    const output = execFileSync('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', updateScript, '-TargetPath', updateTarget, '-RepositoryRoot', master], { encoding: 'utf8' });
    const updateResult = JSON.parse(output);
    assert(updateResult.status === 'blocked_odn_first_adoption_required', 'first scaffold update must block until ODN first adoption completes');
    assert(updateResult.odn_first_adoption_dry_run?.counts?.internal_process_state === 1, 'scaffold update must automatically expose the ODN dry-run classification');
    results.push('first master-scaffold update automatically runs ODN dry-run and blocks unsafe adoption: PASS');
  }

  process.stdout.write(`${JSON.stringify({ status: 'PASS', actual_target_migration: 'not_run_no_target', tests: results }, null, 2)}\n`);
} finally {
  const resolvedTempRoot = path.resolve(os.tmpdir());
  const resolvedFixture = path.resolve(temporaryBase);
  if (!resolvedFixture.startsWith(`${resolvedTempRoot}${path.sep}`) || !path.basename(resolvedFixture).startsWith('odn-traceability-v2-')) {
    throw new Error(`Refusing fixture cleanup outside verified temp root: ${resolvedFixture}`);
  }
  await fs.rm(resolvedFixture, { recursive: true, force: true });
}
