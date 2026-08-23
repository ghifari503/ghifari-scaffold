# SHARED_CONTEXT_POLICY

## Purpose

Keep target repositories safely client-shareable while preserving deterministic internal continuation in the Master Scaffold.

## Authority Boundary

Target shared context is limited to verified, client-safe project facts under:

```text
development/[project-folder]/artifacts/shared/
```

Complete internal lifecycle, handoff, traceability, contributor/process, and development-state metadata resolves from:

```text
artifacts/traceability-local/[project]/
```

The Master Scaffold authority is internal and must never be copied into the target repository. It is identity-free under `INTERNAL_CONTINUITY_IDENTITY_POLICY.md`; routing decisions are ephemeral and never become continuity metadata. The target may expose only opaque `@batch odn-xxxx` source markers and `Batch: odn-xxxx` Git trailers as allowed by `ODN_TRACEABILITY_POLICY.md`.

## Client-Safe Target Context

Target `artifacts/shared/` may contain only concise, verified facts that legitimately form part of the target project contract, for example:

- `PROJECT_STATE.md` containing stable stack, architecture, public module, environment-requirement, and verified behavior facts
- client-approved decision snapshots or public integration facts
- documentation that is safe and useful when the target repository is delivered to a client

It must not contain:

- `ACTIVE_CONTEXT.md`, `CONTRIBUTOR_LOG.md`, or `AI_ROUTING_LOG.md`
- internal handoff files or a `handoffs/` directory
- lifecycle, routing, task, contributor, process, development-state, or internal traceability metadata
- runtime, model, provider, agent, prompt, token, or cost provenance
- secrets, `.env` values, private personal data, credentials, raw chats, or large raw logs

Ordinary business-domain uses of words such as `model`, `provider`, or `agent` are not automatically internal metadata. Classification is evidence-based and file-specific.

## Mandatory Read Order

Before continuing target work, every runtime must read:

1. current scaffold freshness status and `AGENTS.md`
2. root operational state and current task
3. this policy and `ODN_TRACEABILITY_POLICY.md`
4. target `artifacts/shared/PROJECT_STATE.md` and other relevant client-safe facts
5. Master Scaffold `artifacts/traceability-local/[project]/BATCH_STATE.json`
6. at most three relevant ODN batches resolved progressively by component and scope
7. relevant internal handoff from `artifacts/traceability-local/[project]/handoffs/`
8. related root `dev-doc/[feature-name]/`
9. scaffold memory only after current operational, target-fact, and traceability state

Do not load all batch history. Graphify remains the optional authority for structural graph context and is never duplicated into traceability.

## Mandatory Writes After Meaningful Work

After a meaningful implementation slice, pause, blocker, QA closure, handoff, or session close:

- update target `PROJECT_STATE.md` only when client-safe verified project facts changed
- update the active ODN record, batch state, maps, and internal handoff under `artifacts/traceability-local/[project]/`
- update root operational artifacts and activity log under their existing policies
- refresh an installed Graphify graph once for each meaningful target delta and record the status or blocker in internal Master Scaffold state

Do not create internal continuity files in the target merely because an older scaffold version required them.

## First-Adoption Safe Migration

When an existing target adopts a missing or newer Master Scaffold schema boundary, run the schema-versioned migration in `ODN_TRACEABILITY_POLICY.md` and `scripts/odn-traceability.ps1` or `.sh`.

1. Dry-run scans every target `artifacts/shared/` file and classifies it as exactly `client_safe` or `internal_process_state`.
2. `client_safe` files remain untouched.
3. On explicitly approved apply, internal files are copied to Master Scaffold authority and hash-verified before any source removal.
4. Removal is allowed only after every required lifecycle, lookup, Graphify-boundary, reference, and leakage check passes.
5. Prevention rules are added to the target; reruns use completed schema adoption state and create no duplicate state. In-progress or failed state resumes/recover instead of starting an unrelated migration.
6. Git history is reported. It is never rewritten without separate explicit approval.
7. Optionally, after migration completes, the target may adopt `templates/target-leakage-gate/` so its own pre-commit hook and CI block a new explicit AI/runtime/process trace from entering. This is opt-in and founder-approved per target; the Master Scaffold never installs it automatically.

## Authority Order

When evidence conflicts:

1. current target source and current verified evidence
2. founder-locked decisions and approved requirements
3. client-safe target shared facts
4. current Master Scaffold operational and ODN traceability state
5. root `dev-doc/`
6. verified scaffold memory
7. older logs or candidate memory

Internal state never overrides current repository evidence or founder decisions.

## Stop Conditions

Stop before implementation, closure, or handoff when:

- first-adoption classification or required migration verification is incomplete
- internal process state remains in target `artifacts/shared/`
- a required active ODN batch cannot be resolved for a logical change
- the internal handoff or lifecycle state required to resume is missing
- an installed Graphify graph is stale and no internal blocker is recorded
- client-safe context contains secrets or internal metadata
- current evidence conflicts with context and the conflict is not recorded

## Completion Rule

Target work is not `resume_safe`, `SUCCESS`, `ready to pr`, or complete until client-safe target facts and Master Scaffold internal traceability are read and synchronized as applicable. The leakage gate must pass. Actual target migration may only be reported `PASS` after running against that target; when no real target exists use `not_run_no_target`.
