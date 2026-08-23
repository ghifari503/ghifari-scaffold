# Scaffold Version

## Current Release

- version: `2.0.0`
- released_at: `2026-08-23`
- status: `active`
- compatibility: `master scaffold`

## Versioning Policy

This scaffold uses semantic versioning:

- `MAJOR`: an incompatible workflow, guardrail, artifact-path, or runtime-contract change.
- `MINOR`: a backwards-compatible capability, policy, workflow, template, or supported-runtime addition.
- `PATCH`: a backwards-compatible correction, clarification, documentation update, or internal consistency fix.

Update this file as part of every approved scaffold release. A version change must record the corresponding release note or session-log evidence.

## 2.0.0

Major governance release. Target `artifacts/shared/` is now restricted to client-safe facts, while Master Scaffold `artifacts/traceability/[project]/` owns internal ODN, migration, lifecycle, handoff, and continuity state. Existing projects require schema-versioned adoption and migration before the fast path; persisted runtime, provider, model, agent, engineer, and generative-process identity is prohibited. Every runtime now triggers a read-only safe-adoption report after a scaffold change when a target is selected or resumed, blocking unsafe continuation while preserving founder-only apply authority. The release also strengthens mandatory Graphify freshness, documentation closure, task-readiness, and safe-adoption contracts.

## 1.0.0

Initial governed release of the master application-development scaffold, including cross-runtime workflow controls, target-repository boundaries, design-fidelity guidance, and browser-capable Playwright readiness policy.
