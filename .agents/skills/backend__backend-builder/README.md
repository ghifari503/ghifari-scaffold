# Backend Builder Skill

**Status:** Structured routing-ready placeholder

**Purpose:** Agent skill untuk membangun backend modules, services, dan API endpoints berdasarkan architecture decision, development route, dan sprint plan.

**Phase:** Build Phase (B1)

## Required Inputs
- Architecture specification (`artifacts/architecture/`)
- Architecture decision record using `templates/architecture_decision_template.md`
- Development routing rules (`guardrails/development/DEVELOPMENT_STRUCTURE_ROUTING.md`)
- Sprint plan with backend tasks
- Feature scope (per fitur, bukan keseluruhan)

## Routing Logic

Before creating backend folders/files, the skill must read the approved architecture decision and route itself automatically:

- If `architecture_style = monolith_modular`
  - default backend root: `development/apps/api/`
  - feature module root: `development/modules/[feature]/`

- If `architecture_style = microservice`
  - default backend root: `development/services/[service-name]/`

The skill should not ask again where backend folders belong unless the architecture decision is missing or explicitly marked custom.

It must also verify the same route is marked active in:
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/WORKFLOW_STATE.md`

If those files disagree with the architecture decision, stop and request alignment before writing files.

## Expected Outputs
- Backend code files in the approved route
- API documentation
- Database migration files
- Folder creation aligned with selected architecture style

## Notes
- Do not create backend root folders before architecture is finalized.
- Do not write into both monolith and microservice backend trees at once.

