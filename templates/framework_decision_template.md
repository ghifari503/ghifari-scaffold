# Framework Decision Template

## Metadata
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[claude|codex|manual]`
- status: `[draft|approved|superseded]`

## Route Context
- architecture_style: `[monolith_modular|microservice|custom]`
- development_route: `[development/monolith-modular|development/microservices|custom]`
- active_frontend_root: `development/...`
- active_backend_root: `development/...`

## Frontend Stack
- frontend_framework: `[react|vue|nextjs|nuxt|svelte|other]`
- frontend_runtime: `[vite|next-runtime|nuxt-runtime|custom]`
- styling_approach: `[tailwind|css-modules|styled-components|scss|other]`

## Backend Stack
- backend_framework: `[express|nestjs|fastapi|laravel|spring|other]`
- backend_runtime: `[nodejs|python|php|jvm|custom]`
- backend_structure_mode: `[module-based|service-based|custom]`

## Data Layer
- primary_database: `[postgresql|mysql|mongodb|sqlite|other]`
- database_access_layer: `[prisma|drizzle|typeorm|sqlalchemy|django-orm|eloquent|mongoose|other]`
- migration_tooling: `[framework-default|prisma-migrate|alembic|django-migrations|artisan-migrations|other]`
- cache_layer: `[none|redis|other]`
- search_requirement: `[none|postgresql-full-text|elasticsearch|opensearch|other]`

## Tooling
- package_manager: `[npm|pnpm|yarn|bun|pip|poetry|composer|other]`
- testing_stack: `[playwright|cypress|jest|vitest|pytest|mixed|other]`
- api_contract_mode: `[openapi-first|frontend-contract-first|custom]`

## Scaffold Permission
- app_bootstrap_allowed: `[yes|no]`
- bootstrap_blocker: `[framework selection incomplete|approved|custom blocker]`

## Exact Next Step
- `Scaffold app only after this file is approved`
