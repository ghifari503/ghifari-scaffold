# Artifacts

This folder contains project outputs, logs, current state, context, decisions, test evidence, release evidence, and other work products produced while using the scaffold.

Use `artifacts/` only for the active folders defined in `guardrails/development/ARTIFACT_STORAGE_POLICY.md`:

- `access/` - local, development, and demo access inventory
- `architecture/` - architecture decisions, evidence, and API specs
- `context/` - project, business, product, and startup-mode context
- `docker/` - Docker evidence, smoke notes, compose validation, and environment mapping
- `flows/` - user and system flows
- `flutter/` - Flutter intake and Flutter-specific evidence
- `improvement/` - scaffold/process improvement notes and learnings
- `memory/` - persistent scaffold memory, feature registry, task graph, and memory changelog
- `operations/` - current task, workflow state, gates, handoff state, and session logs
- `qa/` - raw QA automation outputs such as Playwright traces, reports, screenshots, and videos
- `release/` - release prep, rollback notes, smoke checklist, and release readiness
- `test/` - human-authored QA summaries, final QA evidence, bug logs, and bug status

Active feature BRD, PRD, design, assets, Figma links, and HTML prototypes belong in `dev-doc/[feature-name]/`.

Reusable scaffold or design templates belong in `templates/`.

Do not create or restore these removed legacy roots:

- `artifacts/brd/`
- `artifacts/prd/`
- `artifacts/design/`

Do not store strict rules, policies, standards, protocols, active feature requirements, active feature design, or reusable templates here.
