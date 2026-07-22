# AI Contributor Development Lifecycle

Use this lifecycle when Codex, Claude, Gemini CLI, or another AI contributor works on a cloned, attached, or scaffold-managed project.

For a new project from zero, first route through `guardrails/development/GREENFIELD_PROJECT_POLICY.md` and `workflows/greenfield_project_workflow.md`; begin this lifecycle after the G1-G4 baseline establishes the target repository and first approved feature slice.

This is an overlay on top of the official scaffold gates. It does not replace `I1/I2` where existing-project onboarding exists, and it does not replace `P1-P7/B1-B3/R1-R4`; it makes the contributor work loop more explicit, more testable, and easier to hand off.

## Goals
- Reduce bugs by establishing baseline state before coding.
- Keep every meaningful decision traceable to requirements, scope, tests, and impact.
- Make handoff between Codex, Claude, Gemini CLI, and future runtimes deterministic.
- Prepare review-ready changes with clear QA, impact, known issues, and PR notes.

## Lifecycle Stages

| # | Stage | Existing Gate Mapping | Required Evidence |
|---|---|---|---|
| 1 | Project Intake | `I1` or `P1` | intake notes, goal, scope, non-scope, acceptance criteria |
| 2 | Clone / Attach Repository | `I1` support | repo URL/path, branch, commit, remote, clean/dirty state |
| 3 | Repository Audit | `I1` | folder map, entrypoints, scripts, config, modules |
| 4 | Stack Identification | `I1` | frontend/backend/mobile/database/API/test/build/tooling stack |
| 5 | Requirement Review | `P1/P2` | linked BRD, PRD, use case, flow, API, schema, design, QA/security docs |
| 6 | Readiness Check | `start dev` support | dependency/env/service/build/lint/test readiness |
| 7 | Local Setup | `start dev` support | local setup status and blocked approvals |
| 8 | Baseline Validation | pre-build support | known startup/build/lint/test/runtime issues before coding |
| 9 | Implementation Planning | `I2/P6/P7` support | scoped plan, allowed paths, test plan, rollback notes |
| 10 | Development Execution | `B1/B2/B3` | scoped changes only, decisions logged, no out-of-scope edits |
| 11 | During-Development QA | `B1/B2/B3` support | incremental test notes after meaningful changes |
| 12 | Self Review | before `R1` | scope, validation, secrets, debug logs, dependency, breaking-change checklist |
| 13 | Final QA | `R2` | granular QA evidence covering unit, integration, E2E/browser, UI/visual, security, performance, and regression checks |
| 14 | Impact Checking | before `R3/R4` | code/API/DB/UI/security/performance/deployment/docs/backward compatibility impact |
| 15 | Documentation & Log Update | after every meaningful step | session log, decision/log/memory updates, known issues, next step |
| 16 | Handoff Preparation | before runtime switch/session end | standard handoff plus Do Not Repeat notes |
| 17 | Ready to PR | after `R4` or PR review gate | PR readiness checklist and reviewer notes |

## Operating Rules
- Do not code before intake, impact scan, baseline validation, implementation plan, allowed write paths, and founder approval exist for the scoped change.
- During intake for a cloned or attached repository, inventory local guardrail files, apply `guardrails/system/GUARDRAIL_PRECEDENCE_POLICY.md`, and resolve conflicts using `guardrails/system/CONFLICT_RESOLUTION_RULE.md` before coding.
- Treat `start dev` as local readiness only. It may create readiness evidence, but it must not become feature implementation.
- Capture existing failures before development so old bugs are not mistaken for new regressions.
- Treat cloned-repo guardrail discovery as incomplete until the minimum checklist in `guardrails/system/CLONED_REPO_INTAKE_CHECKLIST.md` is satisfied.
- Run QA in layers: pre-development reasoning, during-development checks, final QA evidence, then final impact check.
- Use `templates/granular_qa_evidence_template.md` before final impact check whenever the task changes behavior, tests, API contracts, database behavior, UI, security, performance, or release readiness.
- Gemini CLI should be used as an independent reviewer/cross-checker when available; it should not create alternate gates or artifact paths.
- `Ready to PR` means review readiness, not creating a PR on a hosting provider.

## Recommended Multi-Agent Route

Use this route when the founder wants stronger cross-runtime safety or the task is medium/high risk.

| Order | Runtime | Role | Output |
|---|---|---|---|
| 1 | Claude | Requirement analysis, architecture review, risk list, QA scenario planning | scoped plan, risks, test scenarios |
| 2 | Codex/GPT | Implementation, local command execution, unit or targeted test updates | code changes, command output summary, during-dev QA |
| 3 | Gemini CLI | Independent repo-wide cross-check and regression suspicion review | review findings, impact concerns, Do Not Repeat notes |
| 4 | Claude or human reviewer | Final QA reasoning, handoff summary, PR explanation | final notes, reviewer summary, ready-to-PR evidence |

This route is recommended, not mandatory, for low-risk documentation-only work. It becomes mandatory when the founder explicitly requests multi-agent review, independent review, or strict parity validation.

## Recommended Artifact Names
- Readiness baseline: `artifacts/improvement/[project]-readiness-baseline.md`
- Guardrail scan: `artifacts/improvement/[project]-guardrail-scan.md`
- Implementation plan: `artifacts/improvement/[feature]-implementation-plan.md`
- During-dev QA: `artifacts/test/[feature]-during-dev-qa.md`
- Self review: `artifacts/test/[feature]-self-review.md`
- Granular QA evidence: `artifacts/test/[feature]-qa-evidence.md`
- Final impact check: `artifacts/improvement/[feature]-final-impact-check.md`
- PR readiness: `artifacts/release/[feature]-pr-readiness.md`
- Handoff note: `artifacts/operations/[task-id]-handoff.md` when a standalone handoff file is useful
