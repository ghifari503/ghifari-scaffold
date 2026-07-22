# Scaffold Execution Plan

## Metadata
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- status: `draft`

## Route Context
- development_route: `[development/monolith-modular|development/microservices|custom]`
- active_frontend_root: `[path]`
- active_backend_root: `[path]`

## Active Stack
- frontend_framework: `[value]`
- frontend_runtime: `[value]`
- backend_framework: `[value]`
- backend_runtime: `[value]`
- package_manager: `[value]`
- primary_database: `[value]`
- database_access_layer: `[value]`

## Scaffold Status Markers
- stack_signature: `[computed-signature]`
- dry_run_status: `[not_run|completed|stale]`
- dry_run_ran_at: `[timestamp-or-not_run]`
- dry_run_stack_signature: `[signature-or-not_run]`
- real_execute_status: `[not_run|completed]`
- real_execute_ran_at: `[timestamp-or-not_run]`

## Suggested Scaffold Commands
- frontend_command: `[command]`
- backend_command: `[command]`

## Guardrails
- run only inside active route
- confirm package manager and toolchain availability first
- for microservice route, replace service root with the exact target service if needed
