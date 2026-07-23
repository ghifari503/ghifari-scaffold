# Greenfield Project Policy

## Purpose

Provide a strict, token-efficient path for creating a new project from zero without pretending that an existing-project intake or impact scan exists.

This policy applies when `start` finds zero target-project folders under `development/`, excluding only scaffold-owned `_project-template/`. It is separate from the inherited-project route, which begins with `I1 Existing Project Intake`.

## Automatic Start Routing

When the founder sends `start` or `start work`, inspect `development/` with hidden entries included, excluding only scaffold-owned `_project-template/`.

- Zero target-project folders: select `greenfield_project` mode and begin Greenfield Discovery.
- One or more target-project folders: select the existing/inherited-project route, list the detected project folders, and require project selection before continuing.

Do not treat scaffold-owned defaults as target projects. Any eligible target-project folder selects the existing/inherited route until the founder directs otherwise.

## Greenfield Stages

| Stage | Name | Required Outcome | Product Code Allowed |
|---|---|---|---|
| G0 | Auto Route | `development/` state is recorded and the route is selected | no |
| G1 | Founder Discovery | project name, problem, users, desired outcome, first feature candidate, constraints, and available references are known | no |
| G2 | Requirement Baseline | approved project charter and minimum BRD/PRD/acceptance criteria for the first feature | no |
| G3 | Architecture And Bootstrap Plan | approved stack, repository structure, architecture decision, bootstrap plan, test and QA approach | no |
| G4 | Greenfield Pre-Coding Gate | project path, shared context, selected feature slice, skills, allowed write paths, and founder approval are recorded | documentation only |
| G5 | Bootstrap And First Slice | framework and product source may be created only inside approved paths | yes |

## Mandatory G1 Founder Discovery

Before writing requirements or creating a project folder, ask for any available documents, links, diagrams, design files, API references, examples, constraints, or other context.

If none exist, say that the project will be defined through a concise founder interview. Do not invent a product brief, framework, data model, or feature list.

The minimum G1 output is `dev-doc/[project-name]/project-charter.md`, created from `templates/greenfield_project_charter_template.md` after the founder supplies enough information.

## Mandatory G2 Requirement Baseline

Before bootstrap, create only the documentation required for the first approved feature:

- `dev-doc/[project-name]/brd.md` when business requirements are needed
- `dev-doc/[project-name]/prd.md` with first-feature scope, non-scope, acceptance criteria, and user/system flow
- design and API documents only when the first feature needs them
- `templates/feature_task_breakdown_template.md` with exactly one selected slice for the current session

Keep the first feature narrow. Do not create a speculative long-range roadmap or a full application design before the founder approves the initial scope.

## Mandatory G3 Architecture And Bootstrap Plan

Before framework bootstrap, dependency installation, database creation, or source generation, record:

- approved technology stack and rationale
- architecture decision in `artifacts/architecture/DECISION_LOG.md` or an approved architecture decision artifact
- target repository path under `development/[project-folder]`
- initial repository structure and allowed write paths
- dependency choices and justification
- local run, test, lint/typecheck, and QA strategy
- rollback or reset approach while the project is still pre-production
- approved bootstrap plan in `plan/` and a matching approval checklist under `artifacts/operations/plan-approval-checklists/`

Use `templates/greenfield_bootstrap_plan_template.md` for the bootstrap plan.

## Mandatory G4 Gate

Before G5, all of these must be true:

- `G1`, `G2`, and `G3` evidence is complete and founder-approved.
- Exactly one first feature and one selected task slice are active.
- Relevant skills or agents have been found; if none exists, the `skill-creator` flow has run first.
- Target repository shared context exists under `development/[project-folder]/artifacts/shared/`.
- `PROJECT_STATE.md` is created from `templates/shared_project_state_template.md` with `baseline_mode: greenfield_planned`.
- `ACTIVE_CONTEXT.md` and `CONTRIBUTOR_LOG.md` exist and identify the approved bootstrap scope.
- The pre-coding gate lists explicit allowed and blocked write paths.
- Founder approval for the exact bootstrap and first-slice scope is recorded.

## Token-Efficient Rules

1. Start with the founder's first outcome and one feature, not a full product roadmap.
2. Ask grouped, high-information questions and reuse answers across charter, PRD, architecture, and plan artifacts.
3. Read only references supplied by the founder and documents needed for the selected first feature.
4. Prefer existing approved templates; do not generate duplicate narrative across multiple artifacts.
5. Do not research or compare frameworks broadly unless the founder asks for alternatives or a decision cannot be made from stated constraints.
6. Keep uncertain decisions explicit and defer them to the appropriate feature slice instead of guessing.

## Stop Conditions

Stop before G5 if:

- the project name or first feature is unclear;
- founder discovery, requirement baseline, architecture decision, bootstrap plan, or approval is missing;
- a framework, database, dependency, or vendor choice lacks founder approval;
- shared target context or allowed write paths are missing;
- more than one first feature or task slice is active without explicit founder approval.

## Continuity Rules

After G1, G2, G3, G4, G5, a pause, blocker, or handoff, update the target shared context and capture stable decisions, constraints, feature status, and next steps in scaffold memory according to `guardrails/memory/MEMORY_POLICY.md`.
