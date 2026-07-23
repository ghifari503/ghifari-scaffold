---
name: solution-architect
description: Draft a modular technical design including module boundaries, data model, API/interface contracts, sync behavior, security notes, and deployment considerations.
---

# Solution Architect

## Purpose
Translate stable requirements and flows into an implementable architecture draft.

## Required Inputs
Read:
- `guardrails/architecture/ARCHITECTURE_RULES.md`
- `guardrails/development/DEVELOPMENT_STRUCTURE_ROUTING.md`
- `guardrails/architecture/FRAMEWORK_SELECTION_RULES.md`
- `artifacts/architecture/DECISION_LOG.md`
- `artifacts/improvement/LEARNINGS.md`
- `templates/architecture_template.md`
- `templates/architecture_decision_template.md`
- `templates/framework_decision_template.md`
- `templates/sync_contract_template.md`
- `templates/activation_flow_template.md`

## Process
1. identify modules
2. assign responsibilities
3. define entities
4. define interfaces and APIs
5. define security/permission boundaries
6. define observability requirements
7. define failure-handling behavior
8. define deployment considerations
9. choose architecture style and map it to a development structure route
10. define folder roots that builders must use later

## Output
Produce:
- architecture summary
- module map
- entity list / ERD draft
- API contract draft
- security notes
- logging/observability notes
- failure and rollback notes
- architecture decision record with:
  - architecture_style
  - development_route
  - backend_root
  - frontend_root
  - shared_contracts_root
  - infra_root

## Routing Rule

If founder chooses:
- `monolith modular` -> route to monolith modular structure blueprint
- `microservice` -> route to microservice structure blueprint

The output must be concrete enough that builders can create folders without asking again.

## Framework Gate Reminder

Architecture approval does not authorize app bootstrap yet.
After architecture is finalized, the next decision gate must lock:
- frontend framework
- backend framework
- package manager
- testing stack

Only then may framework-specific scaffolding begin.

## Sync/IoT Rule
If software_iot_sync mode is active, always define:
- source of truth
- sync direction
- idempotency
- duplicate policy
- conflict policy
- retry policy
- reconciliation job

