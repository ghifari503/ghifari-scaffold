# COMMANDS

Canonical command list for this scaffold.

Use this file as the single source of truth for user-facing prompt commands, work-session commands, onboarding commands, pre-coding gate commands, and official workflow step commands.

## How To Use

- Copy one command.
- Replace bracketed placeholders.
- Send it to Codex or Claude as your next instruction.
- For official steps, the runtime must run the pre-step check before executing.
- For implementation, `guardrails/development/PRE_CODING_POLICY.md` must be satisfied and `artifacts/operations/PRE_CODING_GATE.md` must allow the current mode.

## Command Ownership

- User triggers commands by typing them as prompts.
- Codex or Claude interprets the command.
- Skills or agents execute the mapped workflow after required checks and founder confirmation.
- Shell commands, dependency installs, migrations, scaffold execution, and product code edits are blocked unless the pre-coding gate allows them.

## Strict I2 Trigger Rule

- `I2 Impact Scan` is required only when the founder intends to change project behavior, source code, committed configuration, data schema, tests tied to a feature change, UI, API, integrations, refactors, or release behavior.
- `I2 Impact Scan` is not required when the founder only wants to prepare, inspect, or run the application locally through `start dev`.
- `start dev` must not ask the founder to name a module or feature unless a real change is needed.
- Local readiness work may inspect dependencies, `.env.example`, local services, documented setup commands, ports, SDK versions, and existing readiness evidence without `I2`.
- If `start dev` discovers that source code, committed config, dependency definitions, migrations, tests, or feature behavior must be changed, stop and transition to `I2` with the discovered problem as the proposed scope.

## Documentation Closure Rule

- Every `medium` or `major` change must end with documentation sync before the runtime may report the activity complete, paused, handed off, or ready for the next item.
- Minimum required operational sync:
  - `artifacts/operations/WORKFLOW_STATE.md`
  - `artifacts/operations/CURRENT_TASK.md`
  - `artifacts/operations/SESSION_LOG.md`
- Also sync every relevant scope artifact that changed meaningfully, such as bug backlog/log/status, design docs, API specs, release notes, `artifacts/improvement/LEARNINGS.md`, `artifacts/architecture/DECISION_LOG.md`, and memory/feature registry artifacts when applicable.
- If no scope-specific document changed beyond the operational trio, record `no additional documentation delta required` in `artifacts/operations/SESSION_LOG.md`.
- The runtime must not move to the next official step, handoff, or `resume_safe` claim until the latest official step is represented in `artifacts/operations/SESSION_LOG.md`.
- The runtime must not mark a `medium` or `major` activity as `SUCCESS`, `fixed`, `verified`, `closed`, `resume_safe`, or `ready to pr` while documentation sync is still pending.

## Medium/Major Plan-First Gate

- Every `medium` or `major` request must stop before execution, produce a compact plan, and wait for explicit founder approval.
- The compact plan must include objective, scope, intended files or artifact areas, execution steps, verification, documentation sync, and risks.
- Before approval, the runtime must not edit files, run official workflow steps, code, build, refactor, install dependencies, run migrations, scaffold/generate code, close QA, prepare release, or create final handoff.
- Small direct questions and lightweight read-only checks may proceed without a plan when they do not change files, gates, or workflow state.
- If a `medium` or `major` task began without approval, stop, mark the activity `PAUSED`, and repair `artifacts/operations/SESSION_LOG.md` before continuing.

## Coding Skill Lookup Gate

- Before any coding, refactor, test creation, scaffold/code generation, dependency work, migration, or build step, the runtime must search for relevant skills or agents first.
- Codex/GPT must prefer `.codex/skills/` and inspect `.codex/agents/` when an agent role is needed; `.claude/` is fallback reference only when no Codex equivalent exists.
- Claude must prefer `.claude/skills/` and inspect `.claude/agents/` when an agent role is needed; `.codex/` is fallback reference only when no Claude equivalent exists.
- Gemini must follow `AGENTS.md`, use available runtime-compatible skill references, and preserve the same gate and artifact evidence shape.
- If no relevant local skill or agent exists for the coding work, use `find-skills` to discover candidates and validate source reputation, usage, license, and capability fit.
- Auto-download only sources listed in `guardrails/system/SKILL_CHECK_POLICY.md`. Install the complete skill folder into both `.codex/skills/` and `.claude/skills/`, then run `cek skill` before use.
- For a candidate outside the allowlist, present the source and wait for founder approval before downloading.
- If no suitable external skill exists, run the `skill-creator` flow first to create or propose the missing skill before coding proceeds.
- Skill lookup, acquisition, or skill creation does not open implementation permission. The pre-coding gate, allowed write paths, impact scan, plan approval, and founder approval still control execution.

## Dev-Doc Discovery Gate

- Before feature development, bugfix work tied to a feature/module, backend/API change, frontend/UI change, system behavior change, integration, refactor, database change tied to a feature/module, or any related build/coding step, search `dev-doc/` for related documentation first.
- Search exact feature slugs, related module/domain names, reasonable synonyms from the request, and entries from `plan/feature-listing.md` when present.
- If related `dev-doc/` material exists, read relevant BRD, PRD, design, prototype, or notes before planning or building.
- If related `dev-doc/` material is missing, record `dev-doc missing`; for new feature work, do not code until founder interview, requirement synthesis, or planning docs create the needed baseline.
- Dev-doc discovery does not open implementation permission. The pre-coding gate, allowed write paths, impact scan, skill lookup, plan approval, and founder approval still control execution.

## Feature Task Slicing And Context-First Gate

- Before feature planning, implementation planning, coding, refactor, QA closure, release prep, or handoff for a feature/module change, enforce `guardrails/development/FEATURE_TASK_SLICING_POLICY.md`.
- Work on exactly one feature per session unless the founder explicitly approves a wider session.
- Break every feature request into small task slices and select only one slice for the current session.
- For medium/major feature work, use `templates/feature_task_breakdown_template.md`.
- Read active operational state, project context, memory index/ledger, feature registry, related `dev-doc/`, and the latest relevant session log before repository source scanning.
- Do not scan or read the whole repository on every task. Use targeted scans from context, memory, dev-doc, impact scan, route names, symbols, modules, and allowed write paths.
- Full repo scans are allowed only for first `I1`, unknown route/stack, stale or contradicted baseline, high-risk/cross-module/security/migration/release work, documented targeted-scan failure, or explicit founder approval.

## Shared Target Repository Context Gate

- For target repo work under `development/[project-folder]`, enforce `guardrails/development/SHARED_CONTEXT_POLICY.md`.
- Shared developer continuity must live in `development/[project-folder]/artifacts/shared/` so it can be carried in the target repo Git history.
- Before continuing target repo work, read `PROJECT_STATE.md`, `ACTIVE_CONTEXT.md`, latest relevant `CONTRIBUTOR_LOG.md` entries, and relevant files under `handoffs/`.
- If shared context is missing during first target repo intake, create the baseline before handoff or implementation.
- After meaningful work, pause, blocker discovery, QA closure, handoff, implementation slice, or session close, update `PROJECT_STATE.md` when project facts change, update `ACTIVE_CONTEXT.md`, append `CONTRIBUTOR_LOG.md`, and create/update the relevant shared handoff file.
- Shared context must be Git-safe and must not contain secrets, `.env` values, raw chat transcripts, credential dumps, private personal data, or large raw logs.

## Code-Derived Baseline Gate

- During first `I1 Existing Project Intake`, enforce `guardrails/development/CODE_DERIVED_BASELINE_POLICY.md` when targeted documentation discovery finds no usable project documentation.
- Ask the founder whether documents, links, diagrams, access to another repository, or other context exists only after the targeted documentation search finds no relevant material.
- If no material exists, create `development/[project-folder]/artifacts/shared/PROJECT_STATE.md` from `templates/shared_project_state_template.md`, then synchronize verified stable facts into scaffold memory and the feature registry.
- Use manifest, configuration, entrypoint, route/API, schema, test, and targeted module evidence before expanding repository scans. Record unknowns instead of guessing.

## Requirement Precedence And Conflict Gate

- Before planning or coding behavior changes, enforce `guardrails/development/REQUIREMENT_PRECEDENCE_POLICY.md`.
- Record the controlling requirement source in the implementation plan after reading relevant founder decisions, PRD, BRD, flows, API/schema constraints, design, security, QA, and current behavior in precedence order.
- When relevant requirement sources conflict or important ambiguity remains, create `dev-doc/[feature-name]/requirement-conflicts/[conflict-id].md` from `templates/requirement_conflict_decision_template.md`.
- Do not code while an unresolved conflict affects scope, acceptance criteria, API/data behavior, security, user flow, or allowed write paths.

## Session Commands

### Start (Automatic Project Route)
```text
start
```

Expected behavior:
- Inspect `development/` with hidden entries included, excluding scaffold-owned `README.md` and `_project-template/`, before asking for a project target.
- If it has zero target-project folders, select `greenfield_project`, report that a new-project discovery is required, and ask for project name, intended outcome, first feature candidate, constraints, and available references. Do not create a framework, install dependencies, or write product code.
- If it has one or more target-project folders, treat the request as existing/inherited-project work, list detected project folders, and continue through the project picker and `I1 Existing Project Intake` route.
- Follow `guardrails/development/GREENFIELD_PROJECT_POLICY.md` for the zero-entry route. `start` does not open a build gate.

### Start Work Session
```text
start work
```

Equivalent aliases:
```text
mulai bekerja
begin work
work
```

Expected behavior:
- Apply the same automatic route as `start`: zero target-project folders starts Greenfield Discovery; one or more target-project folders list detected project folders with numbered choices.
- For the existing/inherited route only, ask the founder to continue by replying with the project number; if the founder already supplied a project path, skip the picker and use that target directly.
- For the greenfield route, ask for the project brief instead of a project number.
- After route selection, read current workflow state.
- Show the selected project, workflow position, active gate, safest next step, and top recommendations.
- Show the command menu from this file.
- Do not execute official steps without confirmation.

### Start Dev
```text
start dev
```

Equivalent aliases:
```text
dev
mulai dev
```

Expected behavior:
- Use the selected project from the active `work` session, or ask for a project target if none is active.
- Treat this command as local development readiness, not feature implementation.
- Do not require `I2 Impact Scan` for local readiness when no project behavior change is requested.
- Read the current workflow state, active gate, pre-coding gate, and any relevant environment-readiness artifact.
- Report whether the project is ready to be developed and run locally.
- If blocked, list the exact missing approvals, missing local setup steps, blocked write areas, and safest next action.
- If local setup is only partially complete, separate `already ready`, `still missing`, and `not yet approved`.
- Do not start feature implementation from this command.
- Do not run dependency installs, migrations, or boot commands unless the gate already allows that scope and the founder confirms.
- If local readiness requires source/config/dependency/schema/test/behavior changes, stop and recommend `I2 Impact Scan` for that discovered change.

### Improve Process
```text
improve
```

Expected behavior:
- Review scaffold rules, docs, workflows, runtime compatibility, and project structure.
- Propose a safe improvement plan first.
- Do not edit files until the founder approves the plan.

### Propose Core Flow Change
```text
propose core flow change
```
Expected behavior:
- Read `guardrails/system/SCAFFOLD_CORE_CHANGE_POLICY.md`.
- Explain why a project-specific extension is insufficient.
- Identify affected protected paths, gates, templates, runtime behavior, and validation.
- Present a compact plan and require founder or CODEOWNERS approval before implementation or merge.

### Improve Skill
```text
improve skill
```

Expected behavior:
- Review the named or relevant skill.
- Propose targeted skill improvements first.
- Do not edit skills until the founder approves the plan.

### Check Skill Catalog
```text
cek skill
```

Equivalent aliases:
```text
check skill
```

Expected behavior:
- Read `guardrails/system/SKILL_CHECK_POLICY.md`.
- Scan `.codex/skills/` and `.claude/skills/`.
- Normalize any new skill folder that is missing the required `category__` prefix.
- Copy missing skill folders so both runtime directories end with the same skill list.
- Refresh `guardrails/system/SKILL_CATALOG.md`.
- Report shared skills, copied folders, and any parity failure.
- Do not edit product code.

### Find Or Acquire A Skill
```text
find skill for: [capability]
```
Expected behavior:
- Search existing `.codex/skills/` and `.claude/skills/` first.
- When no local match exists, use `find-skills` to search external candidates.
- Validate source reputation, usage, license, skill contents, and capability fit before any download.
- Auto-acquire only allowlisted publishers from `guardrails/system/SKILL_CHECK_POLICY.md`; otherwise wait for founder approval.
- Install approved skills as complete, normalized folders in both `.codex/skills/` and `.claude/skills/`, then run `cek skill` to verify runtime synchronization and refresh the catalog.
- If no suitable skill is available, invoke `skill-creator` before coding proceeds.

## AI Contributor Lifecycle Commands

These commands use `workflows/ai_contributor_lifecycle.md` and the matching templates in `templates/`.

### Attach Repo
```text
attach repo
```
Expected behavior:
- Record or inspect the target repository path/URL, branch, commit, remote, and working tree state.
- Do not install dependencies, run migrations, scaffold, or edit product code.
- Continue into `I1 Existing Project Intake` when the target repository is available.

### Readiness Baseline
```text
readiness baseline
```
Expected behavior:
- Use `templates/readiness_baseline_template.md`.
- Capture dependency, env, database, migration, seed, local run, route/healthcheck, build, lint/typecheck, test, formatter, CI/CD, known issue, and blocker status.
- Record CI/CD and formatter discovery, baseline failure classification, and whether the project is safe for the approved scoped development work.
- For an existing project, a completed readiness baseline is mandatory pre-coding evidence; known baseline failures may remain only when they are documented, scoped away from the requested change, and explicitly accepted in the gate evidence.
- Treat this as local readiness evidence; do not start feature implementation.

### Implementation Plan
```text
implementation plan
```
Expected behavior:
- Use `templates/implementation_plan_template.md`.
- Record the controlling requirement source and every active requirement-conflict decision artifact.
- Require completed intake and impact scan for the scoped change.
- Record scope, non-scope, allowed write paths, blocked paths, technical plan, QA plan, rollback notes, founder approval reference, and the matching plan-approval checklist artifact path.
- Before any build/coding step, create or update `artifacts/operations/plan-approval-checklists/[task-id]-[context-name]-plan-approval.md` from `templates/plan_approval_checklist_template.md`.
- Do not edit product code.

### During Dev QA
```text
during dev qa
```
Expected behavior:
- Use `templates/during_dev_qa_log_template.md`.
- Record incremental checks after meaningful implementation changes.
- Separate confirmed issues, fixed issues, deferred issues, and the last passing point.
- Use the impact scan and selected task slice to run the smallest relevant check first. Do not repeat unchanged checks after the last passing point.
- Summarize command results and store large raw output under the approved QA artifact path instead of copying it into operational logs or chat.
- Do not broaden to a full suite without recording an allowed reason from `guardrails/qa/QA_TOKEN_EFFICIENCY_POLICY.md`.
- If the current change is `medium` or `major`, the session log entry for the latest step must be written in the same documentation-sync batch before the next step starts.
- For `medium` or `major` changes, do not close the activity until the required operational and scope-document sync is also recorded.

### Self Review
```text
self review
```
Expected behavior:
- Use `templates/self_review_template.md`.
- Check scope, acceptance criteria, secrets, debug logs, naming, validation, error handling, dependencies, and breaking-change risk before `R1`.

### Final QA Evidence
```text
final qa evidence
```
Expected behavior:
- Use `templates/granular_qa_evidence_template.md`.
- Enforce `guardrails/qa/QA_TOKEN_EFFICIENCY_POLICY.md`: define QA scope from impact evidence, run targeted checks by default, and record any allowed reason for a broad/full suite.
- Record the delta since `last_passing_point`, concise command summaries, and durable evidence paths for large output.
- Record unit, integration, E2E/browser, UI/visual, security, performance, and regression status as `pass`, `fail`, `blocked`, or `skipped`.
- If any QA layer is skipped, record the reason and whether founder approval or baseline evidence exists.
- If UI, layout, responsive behavior, visual state, animation, chart, canvas, generated image, PDF/rendered document, or browser-visible flow needs human judgment, notify the founder that manual visual QA is required.
- Manual visual QA notification must list reason, impacted page/route/state, local URL or screenshot evidence when available, approval checklist, and current blocker/risk status.
- Do not mark `ui_visual` as `pass` until automated evidence is sufficient or founder manual visual approval is recorded.
- Do not claim final QA has passed until required QA layers for the current task type have evidence.
- Write evidence to `artifacts/test/[feature]-qa-evidence.md`.
- This runs before `final impact check` and `ready to pr` for behavior, source, API, database, UI, security, performance, or release-affecting changes.

### Final Impact Check
```text
final impact check
```
Expected behavior:
- Use `templates/final_impact_check_template.md`.
- Check final impact against requirement, scope, code, API, database, UI, user flow, security, performance, deployment, documentation, and backward compatibility.
- Read `artifacts/test/[feature]-qa-evidence.md` when it exists or is required by the task type.
- Fail the check if a `medium` or `major` activity changed behavior/evidence but the related operational or scope documentation was not updated.

### Ready To PR
```text
ready to pr
```
Expected behavior:
- Use `templates/pr_readiness_template.md`.
- Confirm requirement, code scope, tests, regression, final impact, known issues, reviewer notes, and suggested PR summary.
- Confirm documentation sync is complete for any `medium` or `major` work, including `WORKFLOW_STATE`, `CURRENT_TASK`, `SESSION_LOG`, and every relevant scope artifact.
- Confirm the latest official step has a matching session log entry before PR-readiness is accepted.
- This prepares PR readiness evidence; it does not create a remote pull request.

### Handoff
```text
handoff
```
Expected behavior:
- Read the active task, workflow state, latest session log, shared target context, and relevant memory.
- Confirm the current feature and selected task slice.
- Update `PROJECT_STATE.md` when project facts changed, `ACTIVE_CONTEXT.md`, `CONTRIBUTOR_LOG.md`, and the relevant handoff file under `development/[project-folder]/artifacts/shared/handoffs/`.
- Record completed work, remaining work, decisions, changed files, commands and test results, known issues, blockers, Do Not Repeat notes, and the exact next step.
- Do not claim `resume_safe` for medium/major work until the latest official step and required documentation sync are recorded.
- This prepares continuity for another developer or runtime; it does not close QA or approve release.

### Release Readiness
```text
release readiness
```
Expected behavior:
- Treat this as an explicit founder-requested or founder-approved official step.
- Use the release readiness or PR readiness templates in `templates/` as applicable.
- Confirm scope summary, test summary, rollback path, smoke checklist, configuration checklist, backward compatibility, user/data impact, final QA evidence, final impact check, known issues, and release blockers.
- Confirm the latest official step has a matching `SESSION_LOG.md` entry and all required operational and scope documentation is synchronized.
- Distinguish `ready to pr` (review readiness) from `release readiness` (release consideration) and `release` (actual deployment or publication).
- Do not perform deployment, publication, migration, or production action from this command without a separate explicit founder release decision.

### Release
```text
release
```
Expected behavior:
- Require completed release readiness evidence and explicit founder release approval.
- Re-check the approved scope, environment, configuration, smoke checklist, rollback path, and known risks immediately before execution.
- Execute only the approved release action and update release, QA, operational, and shared-context artifacts.
- Stop if release evidence is incomplete, test status is unknown, a blocker is unresolved, or the requested action exceeds the approved scope.

### Feature Listing
```text
feature listing
```
Equivalent aliases:
```text
process feature listing
cek feature listing
```
Expected behavior:
- Read `plan/feature-listing.md`.
- Ignore blank lines and lines beginning with `#`.
- Accept only `new feature/[feature-name]` and `add feature/[feature-name]`.
- Process one feature at a time; do not activate multiple feature entries in the same session unless the founder explicitly approves it.
- For each accepted feature, check required docs in `dev-doc/[feature-name]/`.
- For each accepted feature, check design references in `dev-doc/[feature-name]/design/`.
- Do not look for active feature BRD or PRD in removed legacy roots; use `dev-doc/[feature-name]/brd.md` and `dev-doc/[feature-name]/prd.md`.
- Mark missing docs or design as `missing`; do not invent content.
- Break the selected feature into task slices and choose one slice for the current session.
- For `add feature/[feature-name]`, require impact scan before coding.
- Report recommended next action without opening build gates.

## Numbered Work Menu

Use this menu when the founder starts a guided work session.

```text
COMMAND MENU

ONBOARDING:
  1. I1 - Existing Project Intake
  2. I2 - Impact Scan
  3. Gate - Pre-Coding Gate Check

PLANNING PHASE:
  4. P1 - Founder Interview
  5. P2 - Requirement Synthesis
  6. P3 - User Flow Design
  7. P4 - Design Mapping
  8. P5 - Design Completion
  9. P6 - Solution Architecture
  10. P7 - Sprint Planning

BUILD PHASE:
  11. B1 - Backend Build
  12. B2 - Frontend Build
  13. B3 - IoT Build

REVIEW & RELEASE:
  14. R1 - Code Review
  15. R2 - QA Testing
  16. R3 - Release Prep
  17. R4 - Release Check

UTILITY:
  18. Check workflow status
  19. View learnings and decisions
  20. View project context
  21. View pre-coding gate status
  22. View memory status
  23. Review memory for current task
  24. Run memory curator
  25. View feature registry
  26. Flutter intake checklist
  27. Flutter build
  28. Flutter QA
  29. Start dev
  30. cek skill
  31. attach repo
  32. readiness baseline
  33. implementation plan
  34. during dev qa
  35. self review
  36. final qa evidence
  37. final impact check
  38. ready to pr
  39. feature listing
  40. read shared target context
  41. update shared target context
  0. Exit work session
```

Selection behavior:
- `start`: inspect `development/`; zero entries selects Greenfield Discovery, while one or more entries opens the existing-project picker.
- `work` / `start work`: apply the same route as `start`; use the project picker only when `development/` has one or more entries.
- `1-17`: run the mapped pre-step check before any step work.
- `18`: read `artifacts/operations/WORKFLOW_STATE.md`, `artifacts/operations/CURRENT_PHASE.md`, and `artifacts/operations/CURRENT_TASK.md`.
- `19`: read `artifacts/improvement/LEARNINGS.md` and `artifacts/architecture/DECISION_LOG.md`.
- `20`: read `artifacts/context/PROJECT_CONTEXT.md`, `artifacts/context/BUSINESS_CONTEXT.md`, and `artifacts/context/PRODUCT_SCOPE.md`.
- `21`: read `guardrails/development/PRE_CODING_POLICY.md` and `artifacts/operations/PRE_CODING_GATE.md`.
- `22`: use memory-curator in read-only recall mode; read `guardrails/memory/MEMORY_POLICY.md`, `artifacts/memory/MEMORY_INDEX.md`, and `artifacts/memory/MEMORY_LEDGER.toml`.
- `23`: use memory-curator in read-only recall mode; read active state, then recall only memory relevant to the current task.
- `24`: use memory-curator to capture, sync, prune, or review memory according to the supplied source and scope.
- `25`: use memory-curator in read-only mode; read `artifacts/memory/FEATURE_REGISTRY.md` and `artifacts/memory/FEATURE_REGISTRY.toml`.
- `26`: read `guardrails/flutter/FLUTTER_DEVELOPMENT_POLICY.md` and `artifacts/flutter/FLUTTER_INTAKE_CHECKLIST.md`; do not edit product code.
- `27`: use flutter-builder only after the pre-coding gate is open and allowed write paths exist.
- `28`: use flutter-qa for approved Flutter analyzer/test/smoke scope.
- `29`: treat this as local development readiness for the selected project; inspect gate status, local setup evidence, allowed write paths, and remaining blockers before any real execution.
- `30`: run the skill check policy against `.codex/skills/` and `.claude/skills/`; refresh `guardrails/system/SKILL_CATALOG.md`; do not edit product code.
- `31-39`: run the AI Contributor Lifecycle support command using `workflows/ai_contributor_lifecycle.md`; write scaffold evidence only and respect the pre-coding gate.
- `40`: read `guardrails/development/SHARED_CONTEXT_POLICY.md`, then read target repo `artifacts/shared/ACTIVE_CONTEXT.md`, `CONTRIBUTOR_LOG.md`, and relevant `handoffs/`.
- `41`: update target repo `artifacts/shared/ACTIVE_CONTEXT.md`, append `CONTRIBUTOR_LOG.md`, and create/update the relevant shared handoff from templates.
- `0`: summarize current session and stop.

## Current Safe First Commands

### Current Project State
```text
Review the current scaffold state.
Read artifacts/operations/WORKFLOW_STATE.md, artifacts/operations/CURRENT_PHASE.md, artifacts/operations/CURRENT_TASK.md, guardrails/development/PRE_CODING_POLICY.md, and artifacts/operations/PRE_CODING_GATE.md.
Tell me the safest next action.
Do not edit files.
```

### After Clone Or Copy Into Development
```text
Run I1 Existing Project Intake for:
development/[project-folder]

Mode: read_only_audit.
Do not edit product code.
Do not install dependencies.
Do not run migrations.
Do not scaffold or generate code.
Update scaffold docs only.

Identify:
- project purpose
- frontend/backend roots
- framework stack
- package manager
- database
- test stack
- routes
- major modules
- constraints
- recommended next step
```

### Pre-Coding Gate Check
```text
Check guardrails/development/PRE_CODING_POLICY.md and artifacts/operations/PRE_CODING_GATE.md for the current task.
Report whether coding is allowed.
If blocked, list exactly what is missing.
Do not edit product code.
```

### Classify Task Type
```text
Classify this request before doing any implementation:
[paste request]

Use:
- guardrails/system/TASK_TYPE_CLASSIFICATION.md
- guardrails/system/TASK_TYPE_REGISTRY.md
- templates/task_classification_template.md

Report:
- primary task type
- secondary task types
- confidence
- risk level
- change size: small / medium / major
- whether the Medium/Major Plan-First Gate applies
- whether the Coding Skill Lookup Gate applies
- whether the Dev-Doc Discovery Gate applies
- related `dev-doc/` found, missing, or requires planning baseline
- relevant skill or agent found, missing, or requires `skill-creator`
- required gates
- required artifacts
- required tests/checks
- stop conditions
- whether founder confirmation is required

Do not edit product code.
```

### Define Allowed Write Paths
```text
For this approved scope:
[scope name]

Prepare allowed write paths and blocked paths.
Use the completed intake and impact scan.
Do not edit product code yet.
Update the task or impact-scan artifact only.
```

### Memory Status
```text
Use the memory-curator agent in read-only mode.
Read guardrails/memory/MEMORY_POLICY.md, artifacts/memory/MEMORY_INDEX.md, and artifacts/memory/MEMORY_LEDGER.toml.
Report verified, candidate, superseded, and obsolete memory counts.
List memory entries that need review.
Do not edit files unless I explicitly ask for memory maintenance.
```

### Memory Recall For Current Task
```text
Use the memory-curator agent in read-only mode.
Read active operational state first, then read artifacts/memory/MEMORY_INDEX.md.
Also read artifacts/memory/MEMORY_LEDGER.toml.
Recall only memory relevant to the current task.
If memory conflicts with current artifacts, follow current artifacts and report the conflict.
Do not edit files.
```

### Memory Capture
```text
Use the memory-curator agent.
Capture reusable memory from this source:
[artifact path]

Follow guardrails/memory/MEMORY_CAPTURE_RULES.md.
Write only to artifacts/memory/ and append operational logging if needed.
Do not invent memory from assumptions.
```

### Memory Review And Prune
```text
Use the memory-curator agent.
Review artifacts/memory/ against guardrails/memory/MEMORY_RETENTION_POLICY.md.
Mark stale entries as superseded or obsolete.
Do not delete history unless I explicitly approve deletion.
```

### Run Memory Curator
```text
Use the memory-curator agent.
Mode: [capture|recall|sync|review|prune]
Source or scope:
[artifact path, current task, current session, or decision id]

Keep MEMORY_LEDGER.toml, MEMORY_INDEX.md, category files, and MEMORY_CHANGELOG.md synchronized.
Do not edit product code.
Do not change workflow gates.
```

### Feature Registry Status
```text
Use the memory-curator agent in read-only mode.
Read artifacts/memory/FEATURE_REGISTRY.md and artifacts/memory/FEATURE_REGISTRY.toml.
Report known features/modules, status, current gate, dependencies, impacted systems, blockers, related artifacts, related tests, and risks.
Do not edit files.
```

### Check Skill Catalog
```text
cek skill
```

Expected behavior:
- Read `guardrails/system/SKILL_CHECK_POLICY.md`.
- Run `scripts/check-skills.ps1` on Windows or `scripts/check-skills.sh` on Unix shells.
- Mirror missing skill folders between `.codex/skills/` and `.claude/skills/`.
- Refresh `guardrails/system/SKILL_CATALOG.md`.
- Report shared skills, copied folders, normalized prefixes, and any remaining parity failure.
- Do not edit product code.

### Flutter Intake Checklist
```text
Run Flutter intake checklist for:
development/[project-folder]

Read guardrails/flutter/FLUTTER_DEVELOPMENT_POLICY.md and artifacts/flutter/FLUTTER_INTAKE_CHECKLIST.md.
Mode: read_only_audit.
Do not edit product code.
Do not run flutter pub get.
Do not run builds.
Identify Flutter/Dart SDK constraints, app roots, package roots, state management, routing, platform targets, test stack, flavors, release constraints, and risks.
Update scaffold artifacts only.
```

### Flutter Build
```text
Use the flutter-builder agent.
Scope this Flutter change to:
[feature/module/screen]

Before editing, verify:
- I1 intake is complete
- I2 impact scan is complete
- guardrails/flutter/FLUTTER_DEVELOPMENT_POLICY.md is satisfied
- pre-coding gate is open
- allowed write paths are documented

Preserve existing Flutter architecture, state management, routing, lint, and test conventions.
Do not add dependencies unless explicitly approved.
```

### Flutter QA
```text
Use the flutter-qa agent.
QA scope:
[feature/module/screen]

Read guardrails/flutter/FLUTTER_DEVELOPMENT_POLICY.md and the completed Flutter intake.
Use approved commands only.
Prefer existing project scripts.
Report analyzer, unit/widget/integration test status, platform smoke checks, skipped commands, confirmed issues, and evidence paths.
```

## Existing Project Start

### Minimal Existing Project Start
```text
Start the existing-project onboarding flow.
Audit the current stack, routes, and constraints first.
```

### Start With Current Repo Context
```text
Help me onboard this existing project into the scaffold.
Project summary:
[1-3 paragraph summary]
Current goal:
[feature, bugfix, redesign, revamp, flow change, refactor, migration, or audit]
```

### Start With A Specific Change Scope
```text
Review this existing project and scope only this change:
[feature or module name]
Start with intake and impact scan before planning implementation.
```

### Check Bug Listing
```text
cek bug listing

Read the active root bug listing from:
bug-listing/list-bug.md

If a module is specified, read:
bug-listing/[bug-list-name].md

Bug list names are dynamic. They may be scoped by module, page, role, flow, sprint, release, or regression batch.
Summarize open bugs, missing required fields, severity/status distribution, and the safest next bug-fix scope.
Do not edit product code.
```

### Work From Bug Listing
```text
kerjakan bug backlog

Use the active root bug listing:
bug-listing/list-bug.md

For named bug-list work, use:
bug-listing/[bug-list-name].md

Before coding:
- run or verify intake and impact scan for the selected bug scope
- confirm allowed write paths
- confirm pre-coding gate
- preserve stable bug IDs

After fixing:
- update the root bug listing
- update artifacts/test/[module]-bug-log.md
- update artifacts/test/[module]-bug-status.md
- run required QA, including Playwright for UI/browser-visible bugfixes
```

### Create Bug Listing
```text
Create a root bug listing for module:
[bug-list-name]

Use:
bug-listing/bug-list-template.md

Create or update:
bug-listing/[bug-list-name].md

Use kebab-case names scoped by module, page, role, flow, sprint, release, or regression batch.
Do not create founder-facing bug lists under artifacts/test/bug-list/.
```

### Start With Redesign Or Revamp
```text
Review this existing project and plan a redesign or UI revamp.
Start with intake and impact scan first.
Define the before/after boundary, impacted screens, rollout slices, and regression risks.
Scope:
[area to redesign]
```

### Start With Refactor
```text
Review this existing project and plan a refactor.
Start with intake and impact scan first.
Define what behavior must stay the same, what modules are affected, and how to roll it out safely.
Scope:
[module or subsystem]
```

## Intake And Audit

### Existing Project Intake
```text
Run existing-project intake.
Identify:
- current stack
- frontend/backend roots
- test stack
- major modules
- inherited constraints
- usable project documentation first
- if no relevant documentation exists, ask the founder for references before creating a code-derived `artifacts/shared/PROJECT_STATE.md` baseline
- record source-linked facts, unknowns, and targeted future scan paths; sync verified stable facts to memory
```

### Impact Scan
```text
Run impact scan for this change:
[feature, bugfix, redesign, revamp, flow change, refactor, migration, or module]
List impacted pages, endpoints, modules, docs, tests, allowed write paths, blocked paths, and risks.
Do not edit product code yet.
```

Use `I2 Impact Scan` for requested changes only. Do not use it merely to run or prepare a project locally; use `start dev` for that.

### Architecture And Stack Audit
```text
Audit the current architecture and stack of this existing project.
Do not propose replacements yet.
Show the current system map first.
```

## Planning Phase

### P1 Founder Interview
```text
Run step P1: Founder Interview.
Use this current change request:
[paste request here]
Focus on clarifying the intended delta, not the whole product from zero.
```

### P2 Requirements
```text
Run step P2: Requirements.
Use the intake notes and latest founder clarification.
Generate only the requirement delta for the scoped change.
```

### P3 User Flows
```text
Run step P3: User Flows.
Update only the affected user and system flows for:
[feature or module]
```

### P3 Flow Redesign
```text
Run step P3: User Flows.
This is a flow redesign for:
[journey or feature]
Map the current flow, the target flow, edge cases, and the rollout risks.
```

### P4 Design Mapping
```text
Run step P4: Design Mapping.
Map only the impacted UI areas for:
[page, section, or feature]
```

### P4/P5 UI Revamp
```text
Run step P4: Design Mapping and then P5 Design Complete.
This is a UI revamp for:
[page, surface, or feature]
Keep the scope to the impacted screens and states only.
```

### P5 Design Completion
```text
Run step P5: Design Complete.
Use the design inputs in:
dev-doc/[feature-name]/design/[page]/[section]/assets/
Use HTML UI prototypes, when present, from:
dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/prototype/index.html
Complete only the affected area.
```

### P6 Solution Architecture
```text
Run step P6: Solution Architecture.
Limit the architecture work to the impacted modules, contracts, or data flows only.
```

### P6 Refactor Architecture
```text
Run step P6: Solution Architecture.
This is a refactor or cleanup plan for:
[module or subsystem]
Define safe boundaries, compatibility constraints, and rollout sequence before implementation.
```

### P7 Sprint Planning
```text
Run step P7: Sprint Plan.
Scope the sprint to this feature/module only:
[feature or module name]
```

## Build Phase

Build commands require `guardrails/development/PRE_CODING_POLICY.md` and `artifacts/operations/PRE_CODING_GATE.md` to be satisfied first.

### Frontend Update First
```text
Run step B2: Frontend Build.
Scope it to this page or feature only:
[page or feature name]
Use only the approved allowed write paths.
Preserve the existing project patterns unless a decision says otherwise.
```

### Frontend Revamp Build
```text
Run step B2: Frontend Build.
This is a revamp for:
[page, flow, or surface]
Use only the approved allowed write paths.
Preserve approved behavior changes, document visual diffs, and keep the rollout scoped.
```

### Backend Update
```text
Run step B1: Backend Build.
Scope it to this feature/module only:
[feature or module name]
Use the updated architecture, finalized API delta, and approved allowed write paths.
```

### Backend Refactor Build
```text
Run step B1: Backend Build.
This is a backend refactor for:
[module or subsystem]
Use only the approved allowed write paths.
Keep behavior compatibility unless the approved requirement delta explicitly changes it.
```

### IoT Update
```text
Run step B3: IoT Build.
Scope it to this module only:
[iot module name]
Use only the approved allowed write paths.
Keep compatibility with the current deployed environment.
```

## QA And Release

### Code Review
```text
Run step R1: Code Review.
Review only this module or feature:
[module or feature name]
Prioritize regression risks in the existing system.
```

### QA Testing
```text
Run step R2: QA Testing.
Test only this feature:
[feature name]
Prefer the existing test stack if it is healthy; otherwise use Playwright.
```

### Release Prep
```text
Run step R3: Release Prep.
Prepare release notes, rollback steps, smoke checklist, and user-impact notes for:
[release scope]
```
This is release preparation only. It does not mean the release is approved or ready to execute.

### Release Prep For Revamp Or Refactor
```text
Run step R3: Release Prep.
This release includes redesign, revamp, or refactor work.
Prepare rollback steps, regression smoke checklist, and behavior change notes for:
[release scope]
```

### Release Check
```text
Run step R4: Release Check.
Validate whether this scoped existing-project release is actually ready:
[release scope]
```
Require final QA evidence, final impact check, documentation sync, and explicit founder release decision before any actual deployment or publication.

## Framework And Scaffold

### Confirm Existing Stack
```text
Review the current framework stack and tell me whether it should remain unchanged.
Do not scaffold a replacement unless the current stack is clearly blocking the project.
```

### Framework Change Assessment
```text
Assess whether this existing project should keep or replace its framework stack.
Show tradeoffs first.
Do not execute scaffold changes yet.
```

### Playwright Setup
```text
Set up Playwright for this existing project without polluting the repo root.
Keep all Playwright runtime files under the playwright/ folder.
Respect the current frontend route.
```

## Design Workflow

### Use General Design References
```text
Use the design references in:
templates/design/master-ui-templates/
Then map the relevant patterns into the impacted feature design folder.
```

### Use Figma Reference
```text
Use the Figma reference from:
dev-doc/[feature-name]/design/[page]/[section]/figma-link.txt
Then update only the affected design specs.
```

### Use Uploaded Design Images
```text
Use the uploaded design images from:
dev-doc/[feature-name]/design/[page]/[section]/assets/
Then complete the design specs for that area only.
```

### Use HTML UI Prototype
```text
Use the HTML UI prototype reference from:
dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/prototype/index.html
Treat it as a UI/UX guide only. Do not copy it into production source code unless the approved development scope explicitly says to implement it.
```

## Review And Improvement

### Improve This Existing Project Process
```text
Improve this existing-project scaffold.
Review the runtime rules, onboarding flow, and incremental workflow first.
Do not apply changes yet.
Show me a safe improvement plan.
```

### Improve A Skill
```text
Improve this skill:
[skill name]
Review current project needs and existing-project workflow fit first.
Do not change the skill yet.
Show me the proposed improvement plan.
```

## Good Prompt Patterns

### Limit Scope
```text
Scope this to one feature, module, or fix only:
[scope name]
```

### Preserve Current Conventions
```text
Preserve the current project conventions unless there is an approved decision to change them.
```

### Allow Approved Large Change
```text
This change may include redesign, revamp, flow change, or refactor.
Keep it scoped, impact-scanned, and rollout-safe.
```

### Keep It Short
```text
Keep the output concise and implementation-ready.
```

### Block Real Execution
```text
Dry-run only.
Do not execute real scaffold or destructive changes.
```

### Use Existing Artifacts
```text
Use the existing docs, code patterns, and artifacts in the repository instead of recreating them.
```

### Read Shared Target Context
```text
Read shared target repository context before continuing:
development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md
development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md
development/[project-folder]/artifacts/shared/handoffs/
Then continue with targeted scans only.
```

### Update Shared Target Context
```text
Update shared target repository context for this work session:
development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md
development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md
development/[project-folder]/artifacts/shared/handoffs/[feature]-[slice]-handoff.md
Keep it Git-safe and do not store secrets, raw chat, or large logs.
```

### Slice Feature First
```text
Analyze this feature into small task slices first.
Select only one slice for this session.
Use context, memory, feature registry, and dev-doc before scanning source code.
Do not scan the whole repository unless an allowed reason is documented.
```

## Suggested First Commands

For scaffold maintenance, contributors must create a branch and Pull Request. Only `@odonplay` may update `main`; see `docs/REPOSITORY_GOVERNANCE.md`.

### Codex Model Route

```text
Route this new Codex session by task complexity, accuracy floor, risk, and token efficiency.
Use scripts/codex-route.ps1 in dry-run mode first.
Record only Git-safe routing evidence in the target project's artifacts/shared/AI_ROUTING_LOG.md.
Do not launch or change implementation gates.
```

Windows example:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\codex-route.ps1 --dry-run "Perbaiki bug login yang terisolasi"
```

Add `--launch` only after model availability is confirmed and the normal scaffold gates permit the requested work.

```text
Review the current scaffold state.
Read artifacts/operations/WORKFLOW_STATE.md, artifacts/operations/CURRENT_PHASE.md, artifacts/operations/CURRENT_TASK.md, guardrails/development/PRE_CODING_POLICY.md, and artifacts/operations/PRE_CODING_GATE.md.
Tell me the safest next action.
Do not edit files.
```

```text
Read SCAFFOLD_WORKFLOW.md for the concise end-to-end developer workflow.
Then tell me the safest next action based on the current operational state.
Do not edit files.
```

```text
Run I1 Existing Project Intake for:
development/[project-folder]

Mode: read_only_audit.
Do not edit product code.
Update scaffold docs only.
```

```text
Run impact scan for this change:
[scope]
List impacted pages, endpoints, modules, docs, tests, allowed write paths, blocked paths, and risks.
Do not edit product code yet.
```

