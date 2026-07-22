# Auto-Run Policy

This document defines which actions the system may run automatically and which actions still require explicit founder approval.

## Core Principle

The system may automate technical steps that are:

- reversible
- low-risk
- planning-oriented
- dry-run only

The system must not automate steps that:

- create a real app bootstrap without the required gate
- install dependencies without approval
- write large final scaffold output before the stack decision is approved

## Allowed Auto-Run

### Allowed Immediately After Framework Decision Approval

If all of the following conditions are true:

1. `development_route` is active
2. `framework_decision_status = approved`
3. `app_bootstrap_allowed = yes`
4. `artifacts/operations/CURRENT_PHASE.md` is aligned with `artifacts/operations/WORKFLOW_STATE.md`

then the system may automatically run:

- `scripts/prepare-framework-scaffold.ps1`
- `scripts/prepare-framework-scaffold.sh`
- `scripts/execute-framework-scaffold.ps1` in dry-run mode
- `scripts/execute-framework-scaffold.sh` in dry-run mode

The purpose of this auto-run is to:

- generate `artifacts/architecture/scaffold-execution-plan.md`
- show the real scaffold commands without executing them
- prepare a resume-safe handoff for the next runtime

## Approval-Required Actions

The following actions still require founder approval or a dedicated state flag:

- `execute-framework-scaffold` in real execution mode
- real app bootstrap (`create-next-app`, `nestjs new`, and similar commands)
- dependency installation
- real database migration execution
- destructive overwrite on a target that already contains files

## Required Policy Flags

These policy markers must be visible in the state docs:

- `scaffold_autorun_dry_run: enabled|disabled`
- `scaffold_execute_requires_approval: yes|no`

Default values:

- `scaffold_autorun_dry_run: enabled`
- `scaffold_execute_requires_approval: yes`

## Workflow Behavior

### After framework-selector
The system must:

1. activate the framework decision
2. auto-run scaffold preparation
3. auto-run scaffold execution dry-run
4. update the scaffold execution plan artifact
5. show the result to the founder

### Before real scaffold execution
The system must:

1. show the dry-run result
2. show the frontend and backend commands that would run
3. request founder approval before real execution

## Guardrail

If the active route is `microservices` and the backend target is not yet specific:

- auto-run dry-run may still run
- real backend execution must be delayed until `backend_unit_name` is defined

