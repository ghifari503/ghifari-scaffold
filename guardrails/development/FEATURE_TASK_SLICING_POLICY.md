# FEATURE_TASK_SLICING_POLICY

## Purpose
Keep feature work small, reviewable, and token-efficient by turning every feature request into one scoped task for the current session.

This policy applies before feature planning, implementation planning, coding, refactor, QA closure, release prep, or handoff for a feature or module change.

## Hard Rules

- Work on exactly one feature per session unless the founder explicitly approves a wider session.
- Keep exactly one active task in `artifacts/operations/CURRENT_TASK.md`.
- Before coding, split the requested feature into small tasks that can be implemented, reviewed, and tested independently.
- Select only one task slice for the current session.
- Put all other slices in backlog, next tasks, or a task breakdown artifact. Do not run them in parallel.
- Do not combine unrelated features, modules, refactors, bugfixes, or cleanup into the same active task.
- A task slice is not ready for build until it has objective, scope, acceptance criteria, impacted actor/flow, impacted files or allowed write paths, QA expectation, and founder approval.

## Required Feature Task Breakdown

For every feature request, create or update a compact breakdown using `templates/feature_task_breakdown_template.md`.

The breakdown must identify:

- feature name or slug
- requested outcome
- feature slices
- selected slice for this session
- deferred slices
- dependencies and blockers
- required `dev-doc/` files
- relevant memory/context entries
- target repo shared context entries
- targeted repo scan paths
- allowed write paths
- QA scope

The breakdown may live in:

- `plan/[feature-name]-task-breakdown.md` for approved planning work
- `dev-doc/[feature-name]/implementation-plan.md` when it becomes part of feature source documentation
- `artifacts/operations/CURRENT_TASK.md` as a compact active-slice summary

## Context-First Rule

Before scanning repository source for a feature task, read active context in this order:

1. `artifacts/operations/WORKFLOW_STATE.md`
2. `artifacts/operations/CURRENT_TASK.md`
3. `artifacts/context/PROJECT_CONTEXT.md`
4. `artifacts/context/BUSINESS_CONTEXT.md`
5. `artifacts/context/PRODUCT_SCOPE.md`
6. `guardrails/memory/MEMORY_POLICY.md`
7. `artifacts/memory/MEMORY_INDEX.md`
8. `artifacts/memory/MEMORY_LEDGER.toml`
9. `artifacts/memory/FEATURE_REGISTRY.toml`
10. related `dev-doc/[feature-name]/`
11. latest relevant `artifacts/operations/SESSION_LOG.md` entry
12. when a target repo is attached, `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`
13. when a target repo is attached, latest relevant `development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md` entries and `handoffs/`

Use memory and context to narrow the scan. Memory is advisory and must not override current repo evidence or active artifacts.

## Targeted Scan Rule

After context-first recall, scan only paths likely to be relevant to the selected slice:

- feature or module folders named in `dev-doc/`, memory, feature registry, impact scan, or current task
- routes, controllers, components, services, tests, schemas, configs, or API specs named in evidence
- exact symbols, filenames, route names, endpoint names, table names, or UI labels from the request
- adjacent files needed to understand a local pattern

Start with `rg` or `rg --files` and narrow by feature slug, route, symbol, or module name.

## Full Repo Scan Restriction

Do not read or scan the entire repository for every task.

Full repo scans are allowed only when one of these is true:

- `I1 Existing Project Intake` is running for the first time.
- The active route, stack, or module boundaries are unknown.
- The baseline is stale or contradicted by current evidence.
- The requested change is high-risk, cross-module, security-sensitive, migration-heavy, or release-affecting.
- The targeted scan fails to locate required files and the gap is documented.
- The founder explicitly approves a full scan for the current task.

When a full repo scan is used, record why it was necessary in the plan, current task, or session log.

## Stop Conditions

Stop before implementation if:

- More than one feature is active in the same session.
- No selected slice exists for the current session.
- The task breakdown is missing for medium/major feature work.
- Context and memory recall were skipped.
- Target repo shared context was skipped when a target repo is attached.
- Targeted scan paths are not listed.
- A full repo scan is proposed without an allowed reason.
- Allowed write paths are missing.
- Founder approval for the selected slice is missing.

## Completion Rule

A feature session is not complete until:

- the selected slice status is recorded
- deferred slices remain backlog/next tasks
- memory and feature registry updates are captured when meaningful
- target repo shared context is updated when meaningful work happened
- documentation sync is complete for operational files and relevant feature docs
- the next exact task slice is clear
