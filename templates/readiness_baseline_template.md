# Readiness Baseline Template

## Metadata
- module: `[project-or-feature]`
- artifact_type: `improvement`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[codex|claude|gemini|manual]`
- owner: `founder`
- status: `[draft|in_progress|blocked|done]`
- task_id: `[task-id]`
- resume_safe: `[yes|no]`

## Target Repository
- path_or_url:
- branch:
- commit:
- remote_origin:
- working_tree_state:

## Stack Snapshot
- frontend:
- backend:
- mobile:
- database:
- package_manager:
- test_stack:
- build_tooling:
- formatter:
- ci_cd_pipeline:

## Local Guardrail Status
- local_guardrail_files_found:
- guardrail_scan_artifact:
- explicit_rules_summary:
- inferred_rules_summary:
- conflict_status:
- unresolved_conflicts:

## Local Readiness
- dependency_status:
- environment_status:
- database_status:
- migration_status:
- seed_status:
- local_run_status:
- build_status:
- lint_or_typecheck_status:
- test_status:
- primary_route_or_healthcheck_status:

## Baseline Issues Before Development
- startup_errors:
- runtime_errors:
- failing_tests:
- known_bugs:
- setup_blockers:

## Baseline Failure Classification
- baseline_failure_scope_impact: `[none|outside_approved_scope|inside_approved_scope|unknown]`
- founder_accepted_baseline_exception_reference: `[none|reference]`
- scoped_development_ready: `[yes|no]`

## Decision
- ready_to_develop: `[yes|no|blocked]`
- reason:
- safest_next_step:
