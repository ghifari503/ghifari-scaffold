# Task Type Registry

This registry defines official task types for Codex/GPT, Claude, and Gemini.

Use with `guardrails/system/TASK_TYPE_CLASSIFICATION.md`.

## Registry

| Task Type | Default Risk | Typical Triggers | Required Gates | Required Artifacts | Required Tests / Checks |
|---|---:|---|---|---|---|
| `feature-development` | medium | new feature, add feature, continue feature | intake, impact scan, pre-coding gate | `plan/feature-listing.md`, `dev-doc/[feature]/`, implementation plan, session log | unit/integration/E2E as applicable |
| `bug-fix` | medium | bug, error, fix, not showing, wrong behavior | intake, impact scan, pre-coding gate | `bug-listing/[bug-list-name].md`, bug log, bug status, session log | regression test, Playwright for UI/browser-visible bugs |
| `ui-prototype` | low | HTML prototype, mockup, UI shell, cangkang UI | no pre-coding gate if only writing design reference | `dev-doc/[feature]/design/.../prototype/index.html` | visual review; no product test unless promoted to source |
| `ui-revamp` | medium | redesign, revamp, match design, UI cleanup | impact scan, pre-coding gate for source changes | design docs, screenshots/prototype, session log | Playwright or visual QA |
| `refactor` | high | refactor, clean code, split service, reorganize | impact scan, founder confirmation, pre-coding gate | before/after boundary, decision log if structural | regression tests required |
| `integration` | medium | connect API, integrate service, webhook, external vendor | impact scan, contract review, pre-coding gate | API specs, integration notes, session log | integration tests, E2E when user-facing |
| `database-change` | high | schema, migration, add column, index | impact scan, DB decision, rollback notes, pre-coding gate | migration plan, rollback note, decision log | migration dry-run or verification query |
| `data-migration` | critical | migrate/import/cleanup production data | founder confirmation, backup/rollback, pre-coding gate | migration plan, data validation plan, rollback plan | dry-run, reconciliation, verification query |
| `test-automation` | low | unit test, integration test, Playwright, E2E | existing test stack check | test plan, QA artifact, session log | target test command must be recorded |
| `performance-optimization` | medium | slow, optimize, query heavy, bundle size | impact scan, measurement baseline | benchmark notes, changed paths, session log | before/after measurement |
| `security-fix` | high | security, auth, permission, token, XSS, injection | founder confirmation for exceptions, pre-coding gate | security notes, decision log if exception | security verification, regression tests |
| `dependency-upgrade` | high | upgrade package, update dependency, CVE patch | impact scan, changelog review, pre-coding gate | dependency plan, rollback note, session log | install/build/test matrix |
| `devops-deployment` | high | deploy, CI/CD, release, rollback, env | release approval where needed | release checklist, rollback path, smoke plan | smoke tests, config verification |
| `incident-hotfix` | critical | urgent, production broken, hotfix | founder confirmation, minimal impact scan, rollback | incident notes, hotfix scope, verification evidence | targeted smoke/regression before close |
| `documentation-sync` | low | update docs, sync docs, handoff | none unless paired with source change | updated docs, session log | consistency check |
| `review-only` | low | review, audit, cek, inspect | no coding gate if read-only | review notes/findings | no tests unless requested |
| `legacy-artifact-migration` | medium | migrate old docs/artifacts, move legacy refs | impact scan for source-of-truth changes | migration notes, old/new paths, session log | consistency check |
| `local-dev-readiness` | low | start dev, run locally, check env | no impact scan unless real source/config change appears | readiness notes, blockers | boot/smoke command if approved |

## High-Risk Always Confirm

Always ask founder confirmation before implementation for:

- `refactor`
- `database-change`
- `data-migration`
- `security-fix`
- `dependency-upgrade`
- `devops-deployment`
- `incident-hotfix`
- any task with broad or unclear scope

## Notes

- `ui-prototype` writes design reference artifacts only. If the founder asks to move HTML into source code, reclassify as `feature-development` or `ui-revamp`.
- `local-dev-readiness` is not implementation. If it reveals a required source/config/dependency/schema/test change, pause and reclassify the discovered work.
- `review-only` must not edit product code.

