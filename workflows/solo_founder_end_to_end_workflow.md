# Solo Founder End-to-End Workflow (Frontend First)

This is the recommended workflow for this repository.

Principles:
- Build and validate frontend first.
- Use mockup and visual QA gate before backend implementation.
- Finalize API spec only after frontend contract is validated.
- For new features, update only impacted artifacts (delta), not full restart.
- Every technical "done" must include QA evidence before next gate.

## Step-by-step with output checkpoints

1. Intake and scope clarification (`founder-interviewer`)
Checkpoint output:
- `dev-doc/[feature-name]/interview-notes.md`
- `artifacts/architecture/DECISION_LOG.md` updated for major product decisions

2. Requirement synthesis (`requirement-synthesizer`)
Checkpoint output:
- `dev-doc/[feature-name]/brd.md`
- `dev-doc/[feature-name]/prd.md`
- Explicit acceptance criteria listed

3. Flow definition (`flow-designer`)
Checkpoint output:
- `artifacts/flows/[feature]-user-flow.md`
- `artifacts/flows/[feature]-system-flow.md`
- Happy path + error path + edge cases documented

4. Design structure mapping (`design-mapper`)
Checkpoint output:
- `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/` folders
- `design.md`, `layout.md`, `components.md`, `interactions.md`
- `assets/` folder and `figma-link.txt` placeholder

5. Mockup completion and visual specs
Checkpoint output:
- Designer places images in `assets/` inside the relevant sub-section folder
- Designer fills `figma-link.txt` if using Figma
- If incomplete, run `design-completer` to fill missing states/specs

6. Frontend QA gate on design quality (before coding)
Checkpoint output:
- Design QA checklist passed:
  - all states exist (default, hover, active, disabled, loading, error)
  - responsive rules exist
  - accessibility notes exist
- `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/design.md` marked ready

7. Frontend implementation first (`frontend-builder`)
Checkpoint output:
- Frontend code for the feature completed using mock/stub data if needed
- UI behavior matches design docs and mockup

8. Frontend QA pass (feature-level)
Checkpoint output:
- `artifacts/test/[feature]-frontend-qa.md`
- Visual match pass, responsiveness pass, accessibility pass

9. API spec finalization (from validated frontend contract)
Checkpoint output:
- `artifacts/architecture/api-specs/[feature]-openapi.yaml`
- `artifacts/architecture/api-specs/[feature]-api-spec.md`
- Request/response schema aligned with frontend needs

Architecture routing prerequisite for build:
- approved architecture decision includes:
  - `architecture_style`
  - `development_route`
  - `backend_root`
  - `frontend_root`
  - `shared_contracts_root`

Framework selection prerequisite for app scaffold:
- approved framework decision includes:
  - `frontend_framework`
  - `backend_framework`
  - `primary_database`
  - `database_access_layer`
  - `package_manager`
  - `testing_stack`
  - `app_bootstrap_allowed: yes`

Scaffold auto-run policy after framework approval:
- system auto-runs scaffold preparation
- system auto-runs scaffold dry-run preview
- system writes `artifacts/architecture/scaffold-execution-plan.md`
- real scaffold execute still requires founder approval

Official framework trigger step:
- `framework-selector` approval must immediately trigger:
  1. `activate-framework-decision`
  2. `prepare-framework-scaffold`
  3. `execute-framework-scaffold` in dry-run mode
  4. update scaffold status markers for the active stack

10. API QA pass
Checkpoint output:
- `artifacts/test/[feature]-api-qa.md`
- Contract verification (schema, error format, examples)

11. Backend implementation (`backend-builder`)
Checkpoint output:
- Backend endpoint and business logic built against approved API spec
- Validation and error handling implemented

12. Backend QA pass
Checkpoint output:
- `artifacts/test/[feature]-backend-qa.md`
- Unit + integration checks for backend logic pass

13. DB implementation and DB QA pass
Checkpoint output:
- DB changes documented in architecture and migration notes
- `artifacts/test/[feature]-db-qa.md`
- Migration safety, rollback path, and data integrity checks pass

14. Integration QA and E2E QA (`qa-runner`)
Checkpoint output:
- `artifacts/test/[feature]-integration-qa.md`
- `artifacts/test/[feature]-e2e-qa.md`
- Default automation platform: `Playwright`

15. Security check and security QA signoff
Checkpoint output:
- `artifacts/test/[feature]-security-qa.md`
- Critical security findings resolved or formally accepted by founder

16. Release prep and release check (`release-prep`, `release-checker`)
Checkpoint output:
- `artifacts/release/[feature]-release-prep.md`
- `artifacts/release/[feature]-release-readiness.md`

17. Ship and improve (`improvement-planner`)
Checkpoint output:
- `artifacts/improvement/[feature]-improvement.md`
- `artifacts/improvement/LEARNINGS.md` updated

## Technical Gate Sequence (Mandatory)

- Frontend done -> Frontend QA
- API done -> API QA
- Backend done -> Backend QA
- DB done -> DB QA
- Integration done -> E2E QA
- Security check done -> Security QA signoff
- Release prep done -> Release check

No gate skipping is allowed. If evidence is missing, next gate stays blocked.

## Definition of Done Matrix (Decision-Complete)

| Domain | Minimum Evidence | Pass Criteria | Blocking Rule |
|---|---|---|---|
| Frontend | `artifacts/test/[feature]-frontend-qa.md` | UI match + responsive + accessibility pass | API finalization blocked |
| API | `artifacts/architecture/api-specs/[feature]-openapi.yaml` + `artifacts/test/[feature]-api-qa.md` | Contract complete and verified | Backend build blocked |
| Backend | `artifacts/test/[feature]-backend-qa.md` | Endpoint behavior and error handling pass | Integration QA blocked |
| DB | `artifacts/test/[feature]-db-qa.md` | Migration/data integrity/rollback checks pass | Integration QA blocked |
| Integration | `artifacts/test/[feature]-integration-qa.md` | FE/API/BE/DB flows pass | E2E QA blocked |
| Security | `artifacts/test/[feature]-security-qa.md` | Security checklist pass or approved risk acceptance | Release prep blocked |
| Release | `artifacts/release/[feature]-release-prep.md` + `artifacts/release/[feature]-release-readiness.md` | Release checklist and go-live checks pass | Production release blocked |

## Incremental feature rule (no restart from zero)

When adding a new feature:
- Reuse existing BRD/PRD/flows/design where unchanged.
- Update only impacted files with a Delta Update section.
- Create new files only for new pages, new API endpoints, or new modules.
- Keep history in `artifacts/architecture/DECISION_LOG.md` and `artifacts/improvement/LEARNINGS.md`.

