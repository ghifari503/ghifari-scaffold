# Architecture Decision Template

## Metadata
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[claude|codex|manual]`
- status: `[draft|approved|superseded]`

## Architecture Choice
- architecture_style: `[monolith_modular|microservice|custom]`
- rationale: `...`
- founder_approved: `[yes|no]`

## Development Structure Route
- development_route: `[route-a-monolith-modular|route-b-microservice|custom-route]`
- active_route_status: `[template_only|active]`
- backend_root: `development/...`
- frontend_root: `development/...`
- shared_contracts_root: `development/...`
- infra_root: `development/...`

## Creation Rules
- backend_creation_rule: `...`
- frontend_creation_rule: `...`
- module_or_service_creation_rule: `...`
- shared_package_rule: `...`

## Implementation Notes
- api_contract_location: `artifacts/architecture/api-specs/`
- design_source_location: `dev-doc/[feature-name]/design/`
- qa_evidence_location: `artifacts/test/`

## Exact Next Step
- `Create folder structure for selected route`

## Activation Output (Required)
- Update `artifacts/operations/CURRENT_PHASE.md`
- Update `artifacts/operations/WORKFLOW_STATE.md`
- Confirm only one route is marked active

