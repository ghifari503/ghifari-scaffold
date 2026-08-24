# Scaffold Version

## Current Release

- version: `3.0.0`
- released_at: `2026-08-23`
- status: `active`
- compatibility: `master scaffold`

## Versioning Policy

This scaffold uses semantic versioning:

- `MAJOR`: an incompatible workflow, guardrail, artifact-path, or runtime-contract change.
- `MINOR`: a backwards-compatible capability, policy, workflow, template, or supported-runtime addition.
- `PATCH`: a backwards-compatible correction, clarification, documentation update, or internal consistency fix.

Update this file as part of every approved scaffold release. A version change must record the corresponding release note or session-log evidence.

## 3.0.0

Breaking change: target Git repositories under `development/[project-folder]` must no longer carry any explicit AI/runtime/process trace. Complete per-project ODN/internal continuity authority moves from Git-carried `artifacts/traceability/[project]/` to Git-ignored `artifacts/traceability-local/[project]/`; only `artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json` remains Git-carried, and the ODN schema version increases from `3` to `4` so any prior adoption re-runs migration under the new authority root. The target leakage/share gate now scans the entire target working tree (not only `artifacts/shared/`), excluding dependency/build/`.git` paths, and detects explicit terms such as `codex`, `claude`, `gemini`, `openai`, `anthropic`, or an `ai`/`llm` routing-model-provider-prompt-token-cost term in any non-binary file, including source code. `identity-gate` now also polices the local-only per-project store, distinct from what a target's own Git history may expose. An opt-in, founder-approved-at-adoption pre-commit/CI leakage-gate template is available at `templates/target-leakage-gate/` but is never auto-installed. Existing Git history containing internal-process paths is still only ever reported as `HISTORY_PURGE_REQUIRED`; rewriting it remains a separate, explicitly founder-approved operation.

## 2.0.0

Major governance release. Target `artifacts/shared/` is now restricted to client-safe facts, while Master Scaffold `artifacts/traceability/[project]/` owns internal ODN, migration, lifecycle, handoff, and continuity state. Existing projects require schema-versioned adoption and migration before the fast path; persisted runtime, provider, model, agent, engineer, and generative-process identity is prohibited. Every runtime now triggers a read-only safe-adoption report after a scaffold change when a target is selected or resumed, blocking unsafe continuation while preserving founder-only apply authority. The release also strengthens mandatory Graphify freshness, documentation closure, task-readiness, and safe-adoption contracts.

## 1.0.0

Initial governed release of the master application-development scaffold, including cross-runtime workflow controls, target-repository boundaries, design-fidelity guidance, and browser-capable Playwright readiness policy.
