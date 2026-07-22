# Stack Combination Guide

This document suggests ideal framework + database combinations as a starting point. These are not hard rules, but default recommendations that can be used when the founder does not yet have a final preference.

## How To Use

1. start from the product type
2. choose the closest combination
3. validate whether team constraints, hosting, and internal skills support it
4. save the final decision in `artifacts/architecture/framework-decision.md`

## Recommended Combinations

### 1. B2B SaaS MVP
- frontend: `nextjs`
- frontend_runtime: `next-runtime`
- styling: `tailwind`
- backend: `nestjs`
- backend_runtime: `nodejs`
- primary_database: `postgresql`
- database_access_layer: `prisma`
- cache_layer: `redis` (optional, add only when needed)
- testing_stack: `playwright + vitest + jest`

Why:
- fast to ship
- strong fit for auth, dashboards, CRUD, and admin surfaces
- full TypeScript ecosystem keeps frontend and backend more consistent

### 2. Admin Dashboard / Internal Ops System
- frontend: `react`
- frontend_runtime: `vite`
- styling: `tailwind`
- backend: `fastapi`
- backend_runtime: `python`
- primary_database: `postgresql`
- database_access_layer: `sqlalchemy`
- cache_layer: `none` or `redis`
- testing_stack: `playwright + pytest`

Why:
- lightweight and fast frontend
- Python backend fits automation and data integration well
- very strong match for internal tooling and ops systems

### 3. Content + Marketing + Product Hybrid
- frontend: `nextjs`
- frontend_runtime: `next-runtime`
- styling: `tailwind`
- backend: `nestjs` or `laravel`
- primary_database: `postgresql`
- cache_layer: `redis`
- testing_stack: `playwright`

Why:
- better SSR and SEO behavior
- easy to combine landing pages, docs, onboarding, and product surface

### 4. Fast Modular SPA Product
- frontend: `vue`
- frontend_runtime: `vite`
- styling: `tailwind`
- backend: `nestjs`
- primary_database: `postgresql`
- database_access_layer: `prisma`
- testing_stack: `playwright + vitest`

Why:
- comfortable frontend DX
- good fit for modular interactive apps without heavy SSR needs

### 5. AI Feature Product / Automation Platform
- frontend: `nextjs`
- frontend_runtime: `next-runtime`
- styling: `tailwind`
- backend: `fastapi`
- backend_runtime: `python`
- primary_database: `postgresql`
- database_access_layer: `sqlalchemy`
- cache_layer: `redis`
- testing_stack: `playwright + pytest`

Why:
- Python stack fits AI and data workloads well
- Next.js remains strong for the app shell, auth, and dashboard surface

### 6. Enterprise-Like Modular Monolith
- frontend: `nextjs`
- frontend_runtime: `next-runtime`
- backend: `nestjs`
- primary_database: `postgresql`
- database_access_layer: `prisma` or `typeorm`
- cache_layer: `redis`
- testing_stack: `playwright + jest`

Why:
- very suitable for `monolith_modular`
- boundaries can stay explicit even with one main backend app

### 7. Microservice-Oriented Product
- frontend: `nextjs` or `react`
- backend: `nestjs` or `fastapi`
- primary_database: `postgresql`
- database_access_layer: per-service based on need
- shared_contracts: required
- cache_layer: `redis`
- testing_stack: `playwright + service integration tests`

Why:
- preserves separation across services
- still realistic for a startup without over-engineering too early

## Simple Recommendation Matrix

| Product Type | Recommended Frontend | Recommended Backend | Recommended DB |
|---|---|---|---|
| SaaS MVP | Next.js | NestJS | PostgreSQL |
| Internal Tool | React + Vite | FastAPI | PostgreSQL |
| AI App | Next.js | FastAPI | PostgreSQL |
| Marketing + App | Next.js | NestJS/Laravel | PostgreSQL |
| Modular SPA | Vue + Vite | NestJS | PostgreSQL |
| Microservice | Next.js/React | NestJS/FastAPI | PostgreSQL |

## Default Safe Recommendation

If the founder is unsure and wants a safe default:

- frontend: `nextjs`
- backend: `nestjs`
- database: `postgresql`
- cache: `redis` only when needed
- testing: `playwright`

This is not the only correct answer, but it is the safest starting point for many modern startup products.

