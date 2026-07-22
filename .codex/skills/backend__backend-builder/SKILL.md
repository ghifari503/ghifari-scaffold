---
name: backend-builder
description: >
  Build backend features, services, modules, migrations, or refactor slices from the
  approved architecture decision, confirmed active backend root, sprint plan, and API
  contracts. Use this skill for official backend build step `B1` and whenever backend
  work must be implemented inside an existing or inherited project.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Backend Builder Skill

This skill implements backend work only inside the confirmed active backend root.

## Required Inputs

Read before building:
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/WORKFLOW_STATE.md`
- `guardrails/development/DEVELOPMENT_STRUCTURE_ROUTING.md`
- `artifacts/architecture/framework-decision.md`
- `guardrails/database/DATABASE_SELECTION_RULES.md`
- approved architecture decision
- `artifacts/architecture/`
- `artifacts/architecture/api-specs/`
- sprint plan for the target feature or module

## Active Route Rule

Backend work must stop if:
- architecture route is not selected
- `CURRENT_PHASE.md` and `WORKFLOW_STATE.md` disagree
- route is marked `not_selected`, `template_only`, or otherwise inactive
- framework selection is not approved

## Route Behavior

- Do not assume scaffold template paths.
- Read `active_backend_root` from `artifacts/operations/CURRENT_PHASE.md`.
- If the backend root is a collection root, create or update the scoped backend unit under that root.
- If the project uses a custom structure, follow the confirmed active root exactly.

## Build Flow

1. verify active route
2. verify API contract and architecture inputs
3. verify framework and database decision
4. create or update the folder target inside the active backend root only
5. implement scoped backend behavior
6. add validation, migration approach, and error handling
7. record outputs and follow QA gate requirements

## Folder Scaffolding Helper

Use:
- `scripts/create-development-unit.ps1`
- `scripts/create-development-unit.sh`
- `scripts/prepare-framework-scaffold.ps1`
- `scripts/prepare-framework-scaffold.sh`
- `scripts/execute-framework-scaffold.ps1`
- `scripts/execute-framework-scaffold.sh`
- `scripts/apply-database-starter.ps1`
- `scripts/apply-database-starter.sh`

Examples:
- backend unit under active root -> `backend-unit auth`
- backend service under active root -> `backend-service auth-service`

## Output Expectations

- backend code inside the confirmed active backend root
- supporting docs or migrations as needed
- no writes into inactive roots
- no framework bootstrap until framework decision allows it

