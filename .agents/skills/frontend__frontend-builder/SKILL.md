---
name: frontend-builder
description: >
  Build frontend pages, components, revamps, and UI implementation from approved design
  specs, confirmed active frontend root, sprint plan, and validated API contracts. Use
  this skill for official frontend build step `B2` and whenever frontend work must be
  implemented inside an existing or inherited project.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
---

# Frontend Builder Skill

This skill builds frontend work only inside the confirmed active frontend root.

## Required Inputs

Read before building:
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/WORKFLOW_STATE.md`
- `guardrails/development/DEVELOPMENT_STRUCTURE_ROUTING.md`
- `artifacts/architecture/framework-decision.md`
- approved architecture decision
- `artifacts/design/`
- API contract docs if needed
- sprint plan for the target page, feature, or revamp slice

## Active Route Rule

Frontend work must stop if:
- architecture route is not selected
- `CURRENT_PHASE.md` and `WORKFLOW_STATE.md` disagree
- route is marked `not_selected`, `template_only`, or otherwise inactive
- framework selection is not approved

## Route Behavior

- Do not assume scaffold template paths.
- Read `active_frontend_root` from `artifacts/operations/CURRENT_PHASE.md`.
- Read `active_shared_contracts_root` when implementation needs shared contracts or shared UI types.
- If the project uses a custom structure, follow the confirmed active roots exactly.

## Build Flow

1. verify active route
2. verify design specs and UI source
3. create or update the page or feature folder in the active frontend root only
4. implement states and responsive behavior
5. align with QA and selector rules

## Folder Scaffolding Helper

Use:
- `scripts/create-development-unit.ps1`
- `scripts/create-development-unit.sh`
- `scripts/prepare-framework-scaffold.ps1`
- `scripts/prepare-framework-scaffold.sh`
- `scripts/execute-framework-scaffold.ps1`
- `scripts/execute-framework-scaffold.sh`

Example:
- frontend page -> `frontend-page auth-login`

## Output Expectations

- frontend code inside the confirmed active frontend root
- UI aligned to design docs
- no writes into inactive roots
- no framework bootstrap until framework decision allows it

