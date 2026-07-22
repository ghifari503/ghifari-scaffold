# PRE_CODING_POLICY

## Purpose
Prevent AI runtimes and agents from writing code in the wrong project, route, module, or scope.

This policy applies before any implementation, scaffold execution, dependency install, migration, code generation, refactor, or file edit that changes product code.

Current gate status must be recorded separately in `artifacts/operations/PRE_CODING_GATE.md`.

## Required Before Coding
All items must be true before any runtime may run `B1 Backend Build`, `B2 Frontend Build`, `B3 IoT Build`, or equivalent implementation work.

- Target repository path or URL is known.
- Either the existing-project route has completed `I1 Existing Project Intake` and `I2 Impact Scan` for one scoped change, or the greenfield route has completed approved `G1 Founder Discovery`, `G2 Requirement Baseline`, and `G3 Architecture And Bootstrap Plan` under `guardrails/development/GREENFIELD_PROJECT_POLICY.md`.
- Existing-project route: a completed readiness baseline exists at `artifacts/improvement/[project]-readiness-baseline.md`, records dependency/environment/database/migration/seed/local-run/build/lint-or-typecheck/test/CI/formatter status, and identifies every known pre-existing failure.
- Existing-project route: the readiness baseline declares `scoped_development_ready: yes`, or any baseline failure is documented as not impacting the approved scope with founder acceptance recorded in `artifacts/operations/PRE_CODING_GATE.md`.
- If the request is `medium` or `major`, a compact plan has been presented and explicitly approved by the founder before execution.
- Feature/module work has completed `guardrails/development/FEATURE_TASK_SLICING_POLICY.md`.
- Exactly one feature is active for the current session unless the founder explicitly approved a wider session.
- The feature request has been broken into small task slices, and exactly one slice is selected for the current session.
- For target repo work under `development/[project-folder]`, `guardrails/development/SHARED_CONTEXT_POLICY.md` has been enforced.
- Target repo shared context under `development/[project-folder]/artifacts/shared/` has been read before continuing work.
- If target repo shared context was missing during first intake or greenfield setup, a baseline was created before implementation.
- Context-first recall has completed before repository source scanning.
- Targeted scan paths are documented before repository source scanning.
- Full repo scan is not used unless an allowed reason is documented or the founder explicitly approved it.
- Related `dev-doc/` discovery has completed for feature/module/system behavior work.
- If related `dev-doc/` material exists, the relevant BRD, PRD, design, prototype, or notes have been read before planning/building.
- If related `dev-doc/` material is missing for new feature work, the missing baseline is recorded and founder interview, requirement synthesis, or planning docs have run before coding proceeds.
- `guardrails/development/REQUIREMENT_PRECEDENCE_POLICY.md` has been enforced; controlling requirement source is recorded and no blocking requirement conflict remains.
- Relevant skill or agent lookup has completed for the coding work.
- If no relevant skill or agent exists, the `skill-creator` flow has run first to create or propose the missing skill before coding proceeds.
- A scoped implementation plan is written in the root `plan/` folder for the requested change.
- A matching approved checklist artifact exists under `artifacts/operations/plan-approval-checklists/`.
- `artifacts/operations/CURRENT_TASK.md` has one active task with objective, status, scope, touched artifacts, decisions, remaining work, and exact next action.
- The latest official step has a matching `artifacts/operations/SESSION_LOG.md` entry, or the task context has been repaired before continuing.
- Allowed write paths are listed in `artifacts/operations/CURRENT_TASK.md` or the relevant impact-scan artifact.
- Out-of-scope paths or modules are listed when there is meaningful regression risk.
- Active frontend root, backend root, shared contracts root, and test root are confirmed when applicable.
- Existing-project route: framework, database, package manager, and test stack are audited or explicitly marked unchanged from the target repository. Greenfield route: those choices are explicitly approved in the architecture decision and bootstrap plan.
- Founder approval exists for the scoped build step.
- The founder approval reference recorded in the checklist artifact matches the scoped plan being executed.

## Local Development Readiness Exception

`start dev` is a local readiness path, not a feature/build path.

`I2 Impact Scan` is not required when the founder only wants to:
- inspect whether a project can run locally
- identify missing dependencies or SDKs
- inspect `.env.example` and local env requirements
- check local services, ports, database availability, or documented setup commands
- report the exact steps needed to run the app locally

Local readiness must stop and require `I2 Impact Scan` only when it discovers that local run requires changing source code, committed configuration, dependency definitions, migrations, tests, or feature behavior.

### `local_dev_readiness`
Allowed before `I2`:
- read files and inspect setup scripts
- run non-mutating environment checks
- report missing dependencies, services, env variables, ports, SDK versions, and local run commands
- update scaffold readiness artifacts and operational notes

Requires explicit founder approval and open gate before execution:
- dependency install
- local env file creation
- migration or seed execution
- dev server or emulator boot command

Blocked before `I2`:
- product source edits
- committed configuration changes
- dependency definition changes
- migrations or schema changes
- tests or fixtures tied to a feature change
- refactors or behavior changes

## Allowed Modes

### `read_only_audit`
Allowed:
- read files
- search files
- inspect configs
- run non-mutating checks
- write or update documentation artifacts that describe status, intake, or planning

Blocked:
- product code edits
- dependency installs
- migrations
- framework bootstrap
- scaffold execution
- broad refactors

### `planning_only`
Allowed:
- requirements, flow, design, architecture, and sprint documents
- API contract drafts
- test plan drafts

Blocked:
- implementation edits
- generated app structure
- production configuration changes

### `greenfield_discovery`
Allowed:
- founder interview and reference discovery
- project charter, first-feature BRD/PRD, flow, design, architecture, task breakdown, and bootstrap-plan artifacts
- documentation-only shared context initialization after project name and path are approved

Blocked:
- framework bootstrap
- dependency install
- database creation or migration
- product source generation or edits
- production configuration changes

### `approved_for_build`
Allowed:
- implementation only inside the approved write paths
- tests only inside approved test paths
- docs updates required by the scoped change

Blocked:
- edits outside approved paths
- framework replacement
- unrelated cleanup
- release actions unless release gate is separately approved

### `qa_only`
Allowed:
- run tests
- add or update tests inside approved test paths
- write test evidence

Blocked:
- product behavior changes unless a new build scope is approved

### `release_only`
Allowed:
- release notes
- smoke checklist
- rollback plan
- release readiness evidence

Blocked:
- feature implementation
- scope expansion

## Stop Conditions
Stop and ask the founder for direction if any of these are true:

- Target repository is missing, unless `greenfield_discovery` is the active mode before the founder approves the target project name and path.
- Active task is missing or more than one task is active.
- More than one feature is active in the same session without explicit founder approval.
- A `medium` or `major` request has not received compact-plan approval yet.
- Feature/module work has no task breakdown or selected current-session slice.
- Target repo work is continuing without reading `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`, latest relevant `CONTRIBUTOR_LOG.md`, and relevant `handoffs/`.
- Existing-project readiness baseline is missing, incomplete, stale for the current project state, or does not classify known pre-existing failures.
- Existing-project readiness baseline does not declare scoped development ready and no founder-accepted exception is recorded.
- Target repo shared context is missing after intake and no baseline was created.
- A meaningful target repo session is closing without updating shared context.
- Context-first recall was skipped before repository source scanning.
- Targeted scan paths are missing.
- A full repo scan is proposed without an allowed reason.
- Related `dev-doc/` discovery has not completed for feature/module/system behavior work.
- New feature work has no related `dev-doc/` baseline and planning has not repaired it.
- Controlling requirement source is missing, or a requirement conflict affecting scope, acceptance criteria, API/data behavior, security, user flow, or allowed write paths is unresolved.
- Relevant skill or agent lookup has not completed for coding work.
- No relevant skill exists and `skill-creator` has not run first.
- The latest official step does not have a matching `artifacts/operations/SESSION_LOG.md` entry.
- Existing-project impact scan does not name impacted pages, modules, endpoints, docs, or tests; or greenfield G1-G3 evidence is incomplete.
- Allowed write paths are missing.
- Requested work changes framework, database, deployment, security posture, pricing, roadmap priority, or production incident action.
- The requested edit falls outside the approved scope.

## Required Build Prompt Guard
Before implementation, the runtime must be able to state:

```text
I am allowed to edit only:
- [path/pattern 1]
- [path/pattern 2]

I must not edit:
- [path/pattern 1]
- [path/pattern 2]

The current build gate is approved by:
- [founder approval reference]
```

If this cannot be stated from repository artifacts, implementation must not start.
