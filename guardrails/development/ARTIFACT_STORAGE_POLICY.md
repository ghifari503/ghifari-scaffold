# ARTIFACT_STORAGE_POLICY

## Purpose
Keep scaffold outputs clean, searchable, and stored in the correct source-of-truth location.

This policy applies before creating or updating any scaffold artifact, evidence file, log, QA output, release note, memory entry, planning document, or generated documentation.

## Active Storage Map

- Operational state, scaffold handoff logs, and agent activity log: `artifacts/operations/`
- Local, development, and demo access inventory: `artifacts/access/`
- Project context: `artifacts/context/`
- Architecture decisions, architecture evidence, and API specs: `artifacts/architecture/`
- Docker evidence, smoke notes, compose validation, and environment mapping: `artifacts/docker/`
- Flutter intake and Flutter-specific evidence: `artifacts/flutter/`
- User and system flows: `artifacts/flows/`
- Improvement notes, process evidence, and learnings: `artifacts/improvement/`
- Persistent memory, feature registry, task graph, and memory changelog: `artifacts/memory/`
- Raw QA automation outputs such as Playwright traces, reports, screenshots, and videos: `artifacts/qa/`
- Human-authored QA summaries, final QA evidence, bug logs, and bug status: `artifacts/test/`
- Release prep, rollback notes, smoke checklist, and release readiness: `artifacts/release/`
- Active feature BRD, PRD, design, assets, Figma links, and HTML prototypes: `dev-doc/[feature-name]/`
- Reusable design or scaffold templates: `templates/`
- Git-carried multi-developer continuity for a target repo: `development/[project-folder]/artifacts/shared/`

## Removed Legacy Artifact Roots

These roots must not be recreated:

- `artifacts/brd/`
- `artifacts/prd/`
- `artifacts/design/`

Use these replacements:

- BRD: `dev-doc/[feature-name]/brd.md`
- PRD: `dev-doc/[feature-name]/prd.md`
- Feature design: `dev-doc/[feature-name]/design/`
- Shared design templates: `templates/design/master-ui-templates/`

## Strict Rules

- Do not create new root folders under `artifacts/` without updating this policy and `artifacts/README.md`.
- Do not store active feature requirements or design in `artifacts/`.
- Do not store raw automation output in `artifacts/test/`; use `artifacts/qa/`.
- Do not store human-authored QA summaries in `artifacts/qa/`; use `artifacts/test/`.
- Do not store strict policies or guardrails in `artifacts/`; use `guardrails/`.
- Do not store reusable templates in `artifacts/`; use `templates/`.
- Do not store target repo shared continuity in scaffold-local `artifacts/`; use `development/[project-folder]/artifacts/shared/` so it travels with the target repo.
- Store agent/runtime task activity only in `artifacts/operations/AGENT_ACTIVITY_LOG.md`; do not duplicate it into target `CONTRIBUTOR_LOG.md`, target `AI_ROUTING_LOG.md`, or `SESSION_LOG.md`.
- Before writing an artifact, classify the artifact type and choose the storage path from the Active Storage Map.
- If no correct storage path exists, stop and update this policy before writing the artifact.

## Completion Rule

A scaffold/process, feature, QA, release, or handoff task is not complete until every generated artifact is stored in the correct active location and any outdated path references are repaired.
