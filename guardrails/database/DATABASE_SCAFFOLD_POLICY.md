# Database Scaffold Policy

This document defines which database starter files may be created based on the approved active stack.

## Purpose

After the founder approves the stack, the system may prepare starter files for:

- initial schema or model
- migration baseline
- database access structure

These starter files are not final implementation. Their purpose is to provide a consistent starting point.

## Policy

### Prisma
- typical target:
  - `prisma/schema.prisma`
- use when:
  - backend stack is Node/TypeScript
  - `database_access_layer = prisma`

### Drizzle
- typical target:
  - `src/db/schema.ts`
- use when:
  - backend stack is Node/TypeScript
  - `database_access_layer = drizzle`

### SQLAlchemy
- typical target:
  - `app/models.py`
- use when:
  - backend stack is Python
  - `database_access_layer = sqlalchemy`

### Django ORM
- typical target:
  - `app/models.py`
- use when:
  - backend stack is Django
  - `database_access_layer = django-orm`

### Eloquent
- typical target:
  - `database/migrations/0001_create_example_table.php`
- use when:
  - backend stack is Laravel
  - `database_access_layer = eloquent`

### Mongoose
- typical target:
  - `src/models/example.model.ts`
- use when:
  - backend stack is a MongoDB-backed Node service
  - `database_access_layer = mongoose`

## Microservice Rule

If the active route is `microservice`:

- do not apply the database starter directly to the root `services/`
- define the service target explicitly
- write the starter only into the service currently being built

## Monolith Rule

If the active route is `monolith modular`:

- the database starter may be written to `apps/api/` as the app-level baseline
- specific modules may still add their own files after the baseline exists

## Evidence

After a starter file is created, record it in:

- `artifacts/architecture/scaffold-execution-plan.md`
- `artifacts/operations/SESSION_LOG.md`

