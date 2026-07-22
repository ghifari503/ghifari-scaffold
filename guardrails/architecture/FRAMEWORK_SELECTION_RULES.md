# Framework Selection Rules

This document defines how the system should choose frameworks after the active route is confirmed and before any real app scaffolding begins.

## Core Rule

Do not create app bootstrap files too early.

The system must first lock:

1. `architecture_style`
2. `development_route`
3. `frontend framework/runtime`
4. `backend framework/runtime`
5. `primary database`
6. `database access layer`
7. `package manager`
8. `testing stack`

Only after these decisions are recorded may scaffolding begin.

## Framework Selection Gate

This gate happens after route confirmation and before build scaffolding.

Required outputs:
- `frontend_framework`
- `frontend_runtime`
- `backend_framework`
- `backend_runtime`
- `primary_database`
- `database_access_layer`
- `cache_layer`
- `package_manager`
- `testing_stack`
- `styling_approach`

## Default Decision Pattern

The founder chooses the stack.
The system should present concrete framework choices and then record the final decision.

The system should not assume:
- React
- Vue
- Next.js
- NestJS
- FastAPI
- Laravel
- PostgreSQL
- MySQL
- MongoDB
- Redis

unless the founder explicitly approves it.

## Route Interaction

Framework choice must respect the confirmed active roots:

- frontend app scaffold goes to `active_frontend_root`
- backend app or service scaffold goes to `active_backend_root`
- shared contracts or shared types go to `active_shared_contracts_root`

The exact folder names may differ per project. The scaffold must use the recorded active roots instead of assuming a fixed layout.

## QA Interaction

Testing setup must also wait for framework choice.

Examples:
- Playwright config should not assume Vite, Next.js, or Nuxt before the frontend runtime is selected
- backend QA setup should not assume Express, NestJS, or FastAPI before backend framework is selected
- data test setup should not assume PostgreSQL, MySQL, or MongoDB before database decision is selected

## Database Interaction

Database choice should be reviewed together with backend framework, not as an afterthought.

Use:
- `guardrails/database/DATABASE_SELECTION_RULES.md`
- `guardrails/architecture/STACK_COMBINATION_GUIDE.md`

to guide the founder toward combinations that are realistic and maintainable.

## No-Bootstrap Rule

Before framework selection is approved:
- route confirmation is allowed
- folder creation is allowed
- app bootstrap is not allowed
- dependency installation is not allowed
- generated framework files are not allowed

