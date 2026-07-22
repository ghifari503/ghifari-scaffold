# Framework Scaffold Execution

This document explains how to execute scaffold steps after the route and framework decision are approved.

## Goal

The system must be able to:

1. read the confirmed active roots
2. read the active framework and database decision
3. derive the correct scaffold command
4. write the execution plan to an artifact
5. prepare starter files when needed

## Main Helper Scripts

- `scripts/prepare-framework-scaffold.ps1`
- `scripts/prepare-framework-scaffold.sh`
- `scripts/execute-framework-scaffold.ps1`
- `scripts/execute-framework-scaffold.sh`
- `scripts/apply-database-starter.ps1`
- `scripts/apply-database-starter.sh`

## Execution Order

1. confirm and register the real development route
2. activate framework decision
3. auto-run the prepare framework scaffold plan
4. auto-run the dry-run execution preview
5. create unit, service, module, or page folder if needed
6. apply the database starter for the chosen backend target
7. run real framework bootstrap only when the founder confirms

## Output Artifact

Scaffold planning must be written to:

- `artifacts/architecture/scaffold-execution-plan.md`

This file becomes the handoff-safe source for the next runtime or session.

## Required Status Markers

`scaffold-execution-plan.md` must store the following markers:

- `stack_signature`
- `dry_run_status`
- `dry_run_ran_at`
- `dry_run_stack_signature`
- `real_execute_status`
- `real_execute_ran_at`

These markers are used to verify whether the active stack has already gone through dry-run.

## Guardrails

- Do not run bootstrap if `app_bootstrap_allowed` is still `no`
- Do not scaffold outside the confirmed active roots
- Do not assume service, module, or package names automatically
- Pass an explicit backend unit name when the target backend root is still a collection root
- `execute-framework-scaffold` must default to dry-run mode

## Auto-Run Behavior

After framework decision approval, the system should automatically:

1. run `prepare-framework-scaffold`
2. run `execute-framework-scaffold` in dry-run mode
3. write or update `artifacts/architecture/scaffold-execution-plan.md`
4. show the result to the founder before any real execution step

