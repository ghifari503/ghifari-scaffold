# Templates

This folder contains reusable starting points for scaffold outputs. Templates define a consistent structure; they are not the active documentation or evidence for a project.

## Use

- Copy the relevant template only when a workflow or policy requires the artifact.
- Replace placeholders with verified project evidence.
- Store the completed artifact in its mandated location, such as `dev-doc/`, `plan/`, or `artifacts/`.
- Do not edit a template to record one project's decisions or history.

## Main Groups

- Root Markdown templates: requirements, plans, impact scans, QA, handoffs, releases, and task classification.
- `database/`: starter examples for approved database access layers.
- `design/`: reusable UI baseline materials; active feature design belongs in root `dev-doc/[feature-name]/design/`.
- `development-structure/`: approved project-route structure references.
- `qa/`: Playwright configuration and test examples used by the QA scaffold scripts.
- `traceability/`: Master Scaffold-only ODN batch and internal handoff templates; never copy these into target `artifacts/shared/`.

See `guardrails/development/ARTIFACT_STORAGE_POLICY.md` before creating an artifact.
