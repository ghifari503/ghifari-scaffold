# Database Selection Rules

This document defines how to choose the database after the architecture and framework direction becomes clearer, but before real backend implementation and real migrations are created.

## Core Rule

Do not choose a database only because a framework makes it popular.

Database choice must follow:

1. the primary data shape
2. the primary query pattern
3. transaction requirements
4. reporting and analytics requirements
5. scaling and operational needs

## Required Output

The database decision must at minimum lock:

- `primary_database`
- `database_access_layer`
- `migration_tooling`
- `cache_layer`
- `search_requirement`

## Common Database Choices

### PostgreSQL
Choose this when:
- the product needs a strong relational model
- transactions matter
- the product needs complex queries, filtering, joins, or light-to-medium reporting
- you want one versatile database from MVP through growth stage

Default recommendation:
- the safest default for most SaaS, internal tools, B2B apps, dashboards, and auth-heavy systems

### MySQL
Choose this when:
- the team is more familiar with it
- the product has standard relational needs
- you do not need more advanced PostgreSQL features in the early stage

Default recommendation:
- still valid for many CRUD and business apps, but PostgreSQL is usually the more flexible modern greenfield default

### SQLite
Choose this when:
- the product is a local prototype
- it is a single-user tool
- it is a very small embedded or offline-first case

Do not choose this as the default production backend for a multi-user system.

### MongoDB
Choose this when:
- the data model is highly document-oriented
- the schema must remain very flexible
- complex joins are not a priority

Do not choose it only because it feels "faster to start" when the real domain is relational.

### Redis
Use this for:
- cache
- session storage
- rate limiting
- queue support

Redis is not a replacement for the primary relational database in the core business domain.

## Database Access Layer Suggestions

### TypeScript / Node
- PostgreSQL + Prisma
- PostgreSQL + Drizzle
- MySQL + Prisma
- MongoDB + Mongoose

### Python
- PostgreSQL + SQLAlchemy
- PostgreSQL + Django ORM
- MongoDB + ODM only when the product is truly document-first

### PHP
- PostgreSQL/MySQL + Eloquent (Laravel)

## Cache / Search Notes

### Cache Layer
- use `redis` when:
  - auth or session load is high
  - dashboard queries are frequently repeated
  - rate limiting is needed

### Search Requirement
- use a separate search engine only when real full-text or discovery-heavy behavior is needed
- do not add Elasticsearch/OpenSearch too early for an MVP

## Default Recommendation Pattern

If the founder has no strong preference yet:

- `primary_database`: `postgresql`
- `database_access_layer`: match the approved framework
- `migration_tooling`: framework-native default
- `cache_layer`: `none` at first, `redis` only if traffic/state requires it
- `search_requirement`: `none` unless explicitly needed
