# Framework Scaffold Registry

This document defines the mapping from an approved framework decision to the scaffold pattern that may be used on the active route.

This document does not allow early bootstrap.

Bootstrap or scaffold may only happen if:

1. `architecture_style` has been selected or confirmed
2. `development_route` has been recorded
3. `app_bootstrap_allowed: yes`
4. the framework decision has been recorded in `artifacts/architecture/framework-decision.md`

## Resolution Rule

After the founder approves the stack:

1. read `artifacts/operations/CURRENT_PHASE.md`
2. read `artifacts/operations/WORKFLOW_STATE.md`
3. read `artifacts/architecture/framework-decision.md`
4. resolve the active roots:
   - `active_frontend_root`
   - `active_backend_root`
   - `active_shared_contracts_root`
5. select the scaffold pattern from this registry
6. run scaffold only in the active roots

## Frontend Scaffold Patterns

### React + Vite
- `frontend_framework`: `react`
- `frontend_runtime`: `vite`
- target root: `active_frontend_root`
- notes:
  - suitable for modular SPAs
  - Playwright as the default remains valid

### Vue + Vite
- `frontend_framework`: `vue`
- `frontend_runtime`: `vite`
- target root: `active_frontend_root`
- notes:
  - suitable for modular SPAs
  - use a component or page structure consistent with design specs

### Next.js
- `frontend_framework`: `nextjs`
- `frontend_runtime`: `next-runtime`
- target root: `active_frontend_root`
- notes:
  - suitable for SSR or hybrid rendering
  - QA runner must not assume Vite

### Nuxt
- `frontend_framework`: `nuxt`
- `frontend_runtime`: `nuxt-runtime`
- target root: `active_frontend_root`
- notes:
  - suitable for Vue SSR or hybrid rendering
  - QA runner must not assume Vite

### SvelteKit
- `frontend_framework`: `sveltekit`
- `frontend_runtime`: `sveltekit-runtime`
- target root: `active_frontend_root`
- notes:
  - suitable for products that want a lightweight frontend with SSR flexibility

### Angular
- `frontend_framework`: `angular`
- `frontend_runtime`: `angular-runtime`
- target root: `active_frontend_root`
- notes:
  - suitable when the founder truly needs a stricter enterprise-style structure

## Backend Scaffold Patterns

### Express
- `backend_framework`: `express`
- `backend_runtime`: `nodejs`
- target root: `active_backend_root`

### NestJS
- `backend_framework`: `nestjs`
- `backend_runtime`: `nodejs`
- target root: `active_backend_root`

### FastAPI
- `backend_framework`: `fastapi`
- `backend_runtime`: `python`
- target root: `active_backend_root`

### Laravel
- `backend_framework`: `laravel`
- `backend_runtime`: `php`
- target root: `active_backend_root`

### Fastify
- `backend_framework`: `fastify`
- `backend_runtime`: `nodejs`
- target root: `active_backend_root`

### Django
- `backend_framework`: `django`
- `backend_runtime`: `python`
- target root: `active_backend_root`

### Spring Boot
- `backend_framework`: `springboot`
- `backend_runtime`: `jvm`
- target root: `active_backend_root`

For service-based backends, use the recorded service root or pass an explicit backend unit name when the helper script supports it.

## Database Patterns

### PostgreSQL
- `primary_database`: `postgresql`
- recommended for:
  - SaaS
  - internal tools
  - dashboard apps
  - auth-heavy and transaction-heavy systems

### MySQL
- `primary_database`: `mysql`
- recommended for:
  - conventional CRUD products
  - teams with strong MySQL familiarity

### MongoDB
- `primary_database`: `mongodb`
- recommended for:
  - document-oriented products
  - schema-flexible domains

### SQLite
- `primary_database`: `sqlite`
- recommended for:
  - local prototype
  - single-user or embedded use

### Redis
- `cache_layer`: `redis`
- use for:
  - caching
  - rate limiting
  - sessions
  - queue support

## Shared Package Patterns

### Contracts Package
- used when:
  - the system needs shared API contracts or shared types
- target root: `active_shared_contracts_root`

### UI Shared Package
- used when:
  - the frontend stack needs a shared component or design system package
- target root: a project-approved shared package path, usually a sibling under the same shared area

## Guardrails

- Do not scaffold into multiple routes at once.
- Do not scaffold if route documents are not in sync.
- Do not scaffold if the framework decision is still `draft`.
- Do not scaffold if `app_bootstrap_allowed` is `no`.

## Execution Helpers

- prepare scaffold plan:
  - `scripts/prepare-framework-scaffold.ps1`
  - `scripts/prepare-framework-scaffold.sh`
- execute scaffold:
  - `scripts/execute-framework-scaffold.ps1`
  - `scripts/execute-framework-scaffold.sh`
- apply database starter:
  - `scripts/apply-database-starter.ps1`
  - `scripts/apply-database-starter.sh`

