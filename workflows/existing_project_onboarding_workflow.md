# Existing Project Onboarding Workflow

Use this workflow when the project already exists, was inherited, or was started outside this scaffold.

## Goal
- understand the current system before changing it
- define one safe change scope
- preserve existing patterns unless the founder approves a change
- support both small deltas and larger approved changes such as redesign, revamp, flow change, refactor, and migration

## Step 1: Existing project intake
- The target repository should be cloned or attached under `development/[project-folder]` before intake continues.
- Summarize what the product currently does.
- Inventory local repository guardrail files such as `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursorrules`, `CONTRIBUTING.md`, and `README.md`.
- Create a dedicated guardrail scan using `templates/cloned_repo_guardrail_scan_template.md`.
- Apply `guardrails/system/GUARDRAIL_PRECEDENCE_POLICY.md` and `guardrails/system/CONFLICT_RESOLUTION_RULE.md` during intake, not after coding starts.
- Identify the current framework stack, package manager, database, and test stack.
- Identify frontend root, backend root, shared contracts root, and important infra folders.
- Record inherited constraints, missing docs, and obvious risk zones.
- Stop intake if unresolved local guardrail files, unclear command ownership, write-path mismatch, or hard conflicts remain.

## Step 1.5: Readiness Baseline
- Create `artifacts/improvement/[project]-readiness-baseline.md` from `templates/readiness_baseline_template.md` before implementation planning.
- Record dependency, environment, database, migration/seed, local run, build, lint/typecheck, test, formatter, CI/CD, route or healthcheck, and all pre-existing failures.
- Classify whether each baseline failure is inside or outside the requested scope. Do not start coding while an in-scope or unknown baseline failure remains unresolved unless the founder explicitly accepts the documented risk.

## Step 2: Impact scan
- Define the exact requested change.
- List impacted pages, endpoints, modules, docs, jobs, integrations, and tests.
- Mark what stays untouched.
- For redesign, revamp, or refactor work, also define the before or after boundary and rollout slice.

## Step 3: Clarify intent
- If the requested change is still unclear, run founder interview.
- If intent is already clear, move directly to requirement delta.

## Step 4: Requirement delta
- Update only the impacted requirement docs under `dev-doc/[feature-name]/`.
- Record change reason and expected outcome.
- Enforce `guardrails/development/REQUIREMENT_PRECEDENCE_POLICY.md`; record the controlling source and create a requirement-conflict decision artifact for any relevant conflict or ambiguity.

## Step 5: Flow delta
- Update only the affected user/system flows.
- Keep unchanged flow files as-is.

## Step 6: Design delta
- Update only impacted design folders in `dev-doc/[feature-name]/design/`.
- Keep general mixed references in `templates/design/master-ui-templates/`.
- Full visual revamp is allowed, but it should still be broken into scoped surface areas unless the founder approves a broader launch.

## Step 7: Frontend update first
- Implement the UI change first when UI behavior is part of the request.
- Validate the changed states before expanding backend contracts.

## Step 8: API and backend delta
- Update only impacted API specs in `artifacts/architecture/api-specs/`.
- Implement backend changes against the approved API delta.
- Refactor is allowed when it improves maintainability, but capture architectural consequences in the decision log.

## Step 9: QA and release
- Run scoped regression testing for impacted areas.
- Prepare release notes, rollback plan, and impact notes.

## Mandatory Outputs
- existing project intake summary
- cloned repo guardrail scan
- impacted artifacts list
- updated delta docs
- feature-level QA evidence
- updated API spec when the contract changed
- decision log entry for any meaningful architectural deviation
- learning log entry for notable inherited-system constraints
- rollout notes when the change is a redesign, revamp, or refactor

