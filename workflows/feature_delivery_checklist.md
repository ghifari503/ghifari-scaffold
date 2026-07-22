# Feature Delivery Checklist (Frontend First)

Use this checklist for every feature delivery.

## A. Discovery and scope
- BRD and PRD updated in `dev-doc/[feature-name]/brd.md` and `dev-doc/[feature-name]/prd.md`
- Acceptance criteria explicit and testable

## B. Flows and design
- User and system flow docs created in `artifacts/flows/`
- Design folders generated under `dev-doc/[feature-name]/design/`
- Mockup images saved in `dev-doc/[feature-name]/design/[page]/[section]/assets/`
- Figma reference saved in `dev-doc/[feature-name]/design/[page]/[section]/figma-link.txt` when used
- All required UI states documented
- Design QA gate passed before coding

## C. Frontend first execution
- Frontend implemented and runnable with mock/stub data if backend is not ready
- Frontend QA completed and documented in `artifacts/test/[feature]-frontend-qa.md`
- Visual, responsive, and accessibility checks passed

## D. API and backend
- API spec written after frontend contract stabilizes:
  - `artifacts/architecture/api-specs/[feature]-openapi.yaml`
  - `artifacts/architecture/api-specs/[feature]-api-spec.md`
- Framework decision approved before real scaffold:
  - `artifacts/architecture/framework-decision.md`
- Scaffold execution plan generated automatically after framework approval:
  - `artifacts/architecture/scaffold-execution-plan.md`
- Scaffold status marker for current stack must show dry-run completed before real execute:
  - `dry_run_status = completed`
  - `dry_run_stack_signature = current stack signature`
- API QA documented in `artifacts/test/[feature]-api-qa.md`
- Backend implementation follows approved API spec
- Backend QA documented in `artifacts/test/[feature]-backend-qa.md`

## E. Database and integration
- DB change evidence documented in `artifacts/test/[feature]-db-qa.md`
- Integration QA completed in `artifacts/test/[feature]-integration-qa.md`
- E2E QA completed in `artifacts/test/[feature]-e2e-qa.md`

## F. Security and release
- Security QA completed in `artifacts/test/[feature]-security-qa.md`
- Release prep and readiness docs completed:
  - `artifacts/release/[feature]-release-prep.md`
  - `artifacts/release/[feature]-release-readiness.md`
- Learnings and decisions updated (`artifacts/improvement/LEARNINGS.md`, `artifacts/architecture/DECISION_LOG.md`)

## G. Mandatory Technical Gate Sequence
- Frontend done -> Frontend QA
- API done -> API QA
- Backend done -> Backend QA
- DB done -> DB QA
- Integration done -> E2E QA
- Security check done -> Security QA signoff
- Release prep done -> Release check

Rule: technical done is invalid without corresponding QA evidence artifact.

## H. Definition of Done Matrix

| Domain | Minimum Evidence | Pass Criteria | Blocking Rule |
|---|---|---|---|
| Frontend | `artifacts/test/[feature]-frontend-qa.md` | UI match, responsive, accessibility pass | API finalization blocked |
| API | `artifacts/architecture/api-specs/[feature]-openapi.yaml` + `artifacts/test/[feature]-api-qa.md` | Contract and error schema verified | Backend blocked |
| Backend | `artifacts/test/[feature]-backend-qa.md` | Business rules + validation + error handling pass | Integration blocked |
| DB | `artifacts/test/[feature]-db-qa.md` | Migration safety and data integrity pass | Integration blocked |
| Integration | `artifacts/test/[feature]-integration-qa.md` | Cross-layer flow pass | E2E blocked |
| Security | `artifacts/test/[feature]-security-qa.md` | Security checklist pass or approved risk acceptance | Release prep blocked |
| Release | `artifacts/release/[feature]-release-prep.md` + `artifacts/release/[feature]-release-readiness.md` | Release checklist and readiness pass | Production release blocked |

## I. Gate Simulation Examples
- Scenario 1: frontend done but API not done -> expected status: API gate is next, backend remains blocked.
- Scenario 2: integration done but security QA missing -> expected status: release remains blocked until security signoff.

## J. Incremental change rule
- No full reset of workflow for feature additions
- Only impacted artifacts updated
- Delta notes added in affected docs

