# ODN Traceability And Batch Lifecycle Policy

## Purpose

Provide vendor-neutral change provenance and engineering memory without changing the existing workflow gate order or duplicating Graphify.

## Authority Boundary

- Complete ODN metadata is Project Scaffold local state under `artifacts/traceability-local/[project]/`. That root is local-only: it is never Git-carried by either the Project Scaffold or the Target Project and must never be copied into a Target Project repository.
- `artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json` is the only traceability content the Master Scaffold repository commits to Git; it holds the shared `schema_version` authority and nothing per-project.
- A target repository is client-shareable. It may expose only an opaque `odn-xxxx` reference through a selective `@batch odn-xxxx` source marker and the Git trailer `Batch: odn-xxxx`.
- Target repositories must not contain batch state, ODN registry data, internal handoff, contributor/process state, routing metadata, or runtime/model/provider provenance.
- ODN batch records, state, indexes, maps, handoffs, activity links, adoption state, migration state, and evidence must not use runtime, provider, model, agent, engineer, vendor, or generative-process identity as a field, value, key, identifier, filename, or example. Legacy identity metadata is redacted from the active working tree after source hashing; only neutral migration facts may remain.
- `odn-traceability.mjs identity-gate` polices identity-freedom of Master Scaffold continuity records themselves (the Git-carried schema authority and the Git-ignored local-only per-project store). This is a Master-side content check, not a determination of what is Git-carried; it must not treat the local-only store as if it were a target-shareable artifact. Whether content is safe to expose to a target's own Git history is a separate question answered only by the leakage/share gate below.

## Existing Gate Preservation

ODN resolution is an overlay after normal task classification and before an approved logical source change. It never replaces intake, impact scan, dev-doc discovery, task slicing, skills, plan approval, pre-coding, QA, Graphify refresh, shared-context, documentation sync, handoff, or Git governance.

## Trigger Classification

Every task must additionally be classified as:

- `read_only`: no new batch; relevant lookup is allowed.
- `minor_change`: no new batch unless the change is already part of an active logical batch.
- `logical_change`: create or resume one `odn-xxxx` after component, scope, and implementation intent are clear.

A batch represents one logical engineering change, not a prompt, tool call, file, runtime, conversation turn, or commit.

## Batch Identity And State

- IDs are repository-local, sequential, lowercase, and formatted `odn-0001`, expanding naturally beyond four digits.
- Allocation must use an exclusive reservation lock, collision-check both index and record path, create the record without overwrite, and atomically replace index/state. Simple unprotected `highest + 1` is prohibited.
- Supported states: `active`, `blocked`, `completed`, `cancelled`, and `superseded`.
- `BATCH_STATE.json` supports multiple active logical changes keyed by stable `component:scope`, never by contributor, agent, runtime, model, or provider.
- A follow-up prompt, failed validation, or agent handoff for the same objective resumes the same batch.

## Progressive Context Guardrail

Agents must not load all batch history.

1. Identify component and scope.
2. Use Graphify, when installed, only for structural context.
3. Resolve likely files and symbols.
4. Query the lightweight code/component maps.
5. Load at most three directly relevant batches initially.
6. Expand only through a direct symbol, component, requirement, ADR, dependency, or related-batch reference when the initial context is insufficient.

The registry stores why a change happened, validation, decisions, related batches, and Git provenance. It must not copy ASTs, call graphs, dependency graphs, imports, or Graphify output.

## Source And Git Rules

- Source markers are forward-only, selective, and minimal: `@batch odn-xxxx` using native comment syntax.
- Do not annotate historical source automatically or add a marker for formatting, typo, rename, import cleanup, comments, or minor behavior-neutral refactors.
- Git trailer `Batch: odn-xxxx` is the provenance authority for source-changing logical batches.
- Commit hashes stored internally are derived cache metadata only. Never fabricate them and never automate commits merely to close a batch.
- A source-changing batch remains `active` or `blocked` until required validation, mappings, acceptance criteria, and Git provenance are available.

## Schema Authority And Adoption State

`artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json` is the Master Scaffold schema authority. Its positive integer `schema_version` increases only for a structural or policy change that requires project migration.

Every project has these internal, identity-free records under `artifacts/traceability-local/[project]/`:

- `PROJECT_ADOPTION.json`: `project`, adopted `schema_version`, `migration_status`, and timestamps.
- `MIGRATION_STATE.json`: `from_schema`, `to_schema`, `status`, report identifier, timestamps, and neutral failure evidence.
- `migration-evidence/`: classification and verification evidence.

Allowed migration statuses are `not_started`, `in_progress`, `completed`, `failed`, and `rollback_required`. A migration is complete only when the project schema equals the master schema, status is `completed`, and every required verification passes.

On project initialization or scaffold adoption:

1. Read the master schema and project adoption state.
2. If schema versions match and status is `completed`, take the fast path: do not run migration or its full checklist.
3. If adoption is missing, older, incomplete, failed, or `rollback_required`, require migration.
4. If status is `in_progress`, resume/recover the same migration; do not create an unrelated migration.
5. Runtime, engineer, session, prompt, or handoff changes never trigger migration.

## Schema-Versioned Safe Migration Guardrail

Migration runs once per project per Master Scaffold schema version. It begins as a dry-run and must acquire an exclusive project-and-schema lock before structural or destructive work. A stale or failed migration is recovered using its existing neutral state; a second concurrent migration is blocked.

1. Scan every file under target `artifacts/shared/`.
2. Classify each file as exactly `client_safe` or `internal_process_state` using conservative rules and record the reason and source hash.
3. Never relocate or delete `client_safe` files.
4. Copy every `internal_process_state` file into Master Scaffold authority.
5. Verify destination existence, hash equality, ODN lookup, batch state, internal handoff, lifecycle integration, Graphify boundary, updated shared-context references, and leakage gate.
6. Only after all pre-removal verification passes may an explicitly applied migration remove the source from the target working tree and normal Git tracking.
7. Add target ignore/prevention rules, then run the leakage gate again.
8. Write completed adoption, state, and receipt only after all checks pass. Re-running a completed migration must be idempotent and must not duplicate state.

Dry-run is the default and must create no migration manifest, receipt, copy, or target mutation. A future real mutation requires `--apply`, the exact current `--report-id`, and `--remove-internal-originals`. A required migration never bypasses normal founder approval before mutation. Do not rewrite Git history.

## History And Share Gate

- `odn-traceability.mjs share-gate --target <path>` (the same check `migrate-shared` runs as `projected_leakage_gate`/post-removal `leakage_gate`) recursively scans the entire target working tree, not only `artifacts/shared/`, excluding `.git`, `node_modules`, `dist`, `build`, `coverage`, `.next`, and `graphify-out`. It fails on reserved internal filenames/paths, targeted internal metadata fields, and high-signal internal runtime/process provenance: named operating tools (`Codex CLI`, `Claude Code`, `Gemini CLI`), explicit authorship/handoff/routing statements, or targeted runtime-identity fields carrying a named runtime. Findings are reported as `explicit_ai_trace_paths` for compatibility.
- Report internal-process paths found in target Git history with `HISTORY_PURGE_REQUIRED`, including affected commits and paths.
- History rewriting always requires separate explicit founder approval.
- Leakage checks focus on internal metadata paths, provenance field patterns, and explicit process-identity terms. They must not reject ordinary product-domain uses of AI, LLM, model, provider, token, cost, or agent terms, including product source code and environment configuration. Git branch names and remote URLs are outside the scan because `.git` is excluded.
- Allowed public provenance is limited to `@batch odn-xxxx` and `Batch: odn-xxxx`.

## Target Pre-Commit And CI Leakage Prevention (Opt-In Template)

- `templates/target-leakage-gate/` provides a self-contained scanner (`odn-leakage-scan.mjs`), a `pre-commit` hook, and a GitHub Actions workflow (`odn-leakage-gate.yml`) that a target repository can adopt so the same explicit-trace scan blocks a new leak locally and in CI.
- These templates are copied into a target only during an explicit, founder-approved adoption step; the Master Scaffold never writes into a target repository automatically, and adopting the template does not itself constitute or replace the ODN migration guardrail.
- The template scanner is standalone: it does not depend on the Master Scaffold path or on `odn-traceability.mjs`, so it keeps working if the target repository is cloned or hosted independently.

## Completion Checklist

All required results must be `PASS` before removal or migration completion:

- Master Scaffold copy exists
- ODN lookup
- Batch state resolution
- Internal handoff
- Lifecycle integration
- Graphify boundary
- Shared-context references updated
- Leakage gate
- Identity-free internal state

When no real target exists, validate the mechanism with isolated fixtures and report actual target migration as `not_run_no_target`, not `PASS`.
