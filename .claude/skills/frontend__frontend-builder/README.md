# Frontend Builder Skill

**Status:** Structured routing-ready placeholder

**Purpose:** Agent skill untuk membangun frontend pages, components, dan UI berdasarkan design specs, API contracts, dan architecture-driven folder routing.

**Phase:** Build Phase (B2)

## Required Inputs
- Design specs (`artifacts/design/`)
- Architecture decision record using `templates/architecture_decision_template.md`
- Development routing rules (`guardrails/development/DEVELOPMENT_STRUCTURE_ROUTING.md`)
- Backend API contracts
- Sprint plan with frontend tasks

## Routing Logic

Before creating frontend folders/files, the skill must read the approved architecture decision and route itself automatically:

- For `monolith_modular`
  - default frontend root: `development/apps/web/`

- For `microservice`
  - default frontend root: `development/apps/web/`
  - consume shared contracts from `development/packages/contracts/` or equivalent approved route

The skill should not ask the founder where the frontend app folder belongs if the architecture decision already defines it.

It must also verify the same route is marked active in:
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/WORKFLOW_STATE.md`

If those files disagree with the architecture decision, stop and request alignment before writing files.

## Expected Outputs
- Frontend component code
- Page implementations
- Styling files
- Folder creation aligned with selected architecture route

## Notes
- Do not create frontend root folders before architecture is finalized.
- Frontend folder path must follow the active architecture route, not ad-hoc naming.

