#!/usr/bin/env bash
set -euo pipefail

WRITE_STARTER_FILES="no"
if [[ "${1:-}" == "--write-starter-files" ]]; then
  WRITE_STARTER_FILES="yes"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CURRENT_PHASE="$REPO_ROOT/docs/CURRENT_PHASE.md"
FRAMEWORK_DECISION="$REPO_ROOT/docs/artifacts/architecture/framework-decision.md"
OUTPUT_PLAN="$REPO_ROOT/docs/artifacts/architecture/scaffold-execution-plan.md"

get_line_value() {
  local file="$1"
  local key="$2"
  local line
  line="$(grep -E "^- ${key}:" "$file" | head -n 1 || true)"
  line="${line#- $key: }"
  line="${line//\`/}"
  echo "$line"
}

ensure_directory() {
  mkdir -p "$1"
}

DEVELOPMENT_ROUTE="$(get_line_value "$CURRENT_PHASE" "development_route")"
FRONTEND_ROOT="$(get_line_value "$CURRENT_PHASE" "active_frontend_root")"
BACKEND_ROOT="$(get_line_value "$CURRENT_PHASE" "active_backend_root")"
FRONTEND_FRAMEWORK="$(get_line_value "$FRAMEWORK_DECISION" "frontend_framework")"
FRONTEND_RUNTIME="$(get_line_value "$FRAMEWORK_DECISION" "frontend_runtime")"
BACKEND_FRAMEWORK="$(get_line_value "$FRAMEWORK_DECISION" "backend_framework")"
BACKEND_RUNTIME="$(get_line_value "$FRAMEWORK_DECISION" "backend_runtime")"
PACKAGE_MANAGER="$(get_line_value "$FRAMEWORK_DECISION" "package_manager")"
PRIMARY_DATABASE="$(get_line_value "$FRAMEWORK_DECISION" "primary_database")"
DATABASE_ACCESS_LAYER="$(get_line_value "$FRAMEWORK_DECISION" "database_access_layer")"
APP_BOOTSTRAP_ALLOWED="$(get_line_value "$FRAMEWORK_DECISION" "app_bootstrap_allowed")"

if [[ "$APP_BOOTSTRAP_ALLOWED" != "yes" ]]; then
  echo "App bootstrap is not allowed yet. Activate framework decision first."
  exit 1
fi

FRONTEND_KEY="${FRONTEND_FRAMEWORK}|${FRONTEND_RUNTIME}|${PACKAGE_MANAGER}"
BACKEND_KEY="${BACKEND_FRAMEWORK}|${BACKEND_RUNTIME}|${PACKAGE_MANAGER}"

case "$FRONTEND_KEY" in
  "react|vite|pnpm") FRONTEND_COMMAND="pnpm create vite $FRONTEND_ROOT --template react-ts" ;;
  "react|vite|npm") FRONTEND_COMMAND="npm create vite@latest $FRONTEND_ROOT -- --template react-ts" ;;
  "vue|vite|pnpm") FRONTEND_COMMAND="pnpm create vue@latest $FRONTEND_ROOT" ;;
  "vue|vite|npm") FRONTEND_COMMAND="npm create vue@latest $FRONTEND_ROOT" ;;
  "nextjs|next-runtime|pnpm") FRONTEND_COMMAND="pnpm create next-app $FRONTEND_ROOT --ts --app" ;;
  "nextjs|next-runtime|npm") FRONTEND_COMMAND="npx create-next-app@latest $FRONTEND_ROOT --ts --app" ;;
  "nuxt|nuxt-runtime|pnpm") FRONTEND_COMMAND="pnpm dlx nuxi@latest init $FRONTEND_ROOT" ;;
  "nuxt|nuxt-runtime|npm") FRONTEND_COMMAND="npx nuxi@latest init $FRONTEND_ROOT" ;;
  *) FRONTEND_COMMAND="Manual scaffold required for frontend stack: $FRONTEND_FRAMEWORK / $FRONTEND_RUNTIME / $PACKAGE_MANAGER" ;;
esac

case "$BACKEND_KEY" in
  "nestjs|nodejs|pnpm") BACKEND_COMMAND="pnpm dlx @nestjs/cli new $BACKEND_ROOT" ;;
  "nestjs|nodejs|npm") BACKEND_COMMAND="npx @nestjs/cli new $BACKEND_ROOT" ;;
  "express|nodejs|pnpm") BACKEND_COMMAND="mkdir -p $BACKEND_ROOT && cd $BACKEND_ROOT && pnpm init" ;;
  "fastify|nodejs|pnpm") BACKEND_COMMAND="mkdir -p $BACKEND_ROOT && cd $BACKEND_ROOT && pnpm init" ;;
  "fastapi|python|poetry") BACKEND_COMMAND="mkdir -p $BACKEND_ROOT && cd $BACKEND_ROOT && poetry init" ;;
  "fastapi|python|pip") BACKEND_COMMAND="mkdir -p $BACKEND_ROOT && cd $BACKEND_ROOT && python -m venv .venv" ;;
  "django|python|pip") BACKEND_COMMAND="django-admin startproject app $BACKEND_ROOT" ;;
  "laravel|php|composer") BACKEND_COMMAND="composer create-project laravel/laravel $BACKEND_ROOT" ;;
  *) BACKEND_COMMAND="Manual scaffold required for backend stack: $BACKEND_FRAMEWORK / $BACKEND_RUNTIME / $PACKAGE_MANAGER" ;;
esac

NOW="$(date -Iseconds)"
STACK_SIGNATURE="${DEVELOPMENT_ROUTE}|${FRONTEND_FRAMEWORK}|${FRONTEND_RUNTIME}|${BACKEND_FRAMEWORK}|${BACKEND_RUNTIME}|${PACKAGE_MANAGER}|${PRIMARY_DATABASE}|${DATABASE_ACCESS_LAYER}"
cat > "$OUTPUT_PLAN" <<EOF
# Scaffold Execution Plan

## Metadata
- created_at: $NOW
- updated_at: $NOW
- status: draft

## Route Context
- development_route: $DEVELOPMENT_ROUTE
- active_frontend_root: $FRONTEND_ROOT
- active_backend_root: $BACKEND_ROOT

## Active Stack
- frontend_framework: $FRONTEND_FRAMEWORK
- frontend_runtime: $FRONTEND_RUNTIME
- backend_framework: $BACKEND_FRAMEWORK
- backend_runtime: $BACKEND_RUNTIME
- package_manager: $PACKAGE_MANAGER
- primary_database: $PRIMARY_DATABASE
- database_access_layer: $DATABASE_ACCESS_LAYER

## Scaffold Status Markers
- stack_signature: $STACK_SIGNATURE
- dry_run_status: not_run
- dry_run_ran_at: not_run
- dry_run_stack_signature: not_run
- real_execute_status: not_run
- real_execute_ran_at: not_run

## Suggested Scaffold Commands
- frontend_command: $FRONTEND_COMMAND
- backend_command: $BACKEND_COMMAND

## Guardrails
- run only inside confirmed active roots
- confirm package manager and toolchain availability first
- pass an explicit backend unit name if the backend root is still a collection root
EOF

if [[ "$WRITE_STARTER_FILES" == "yes" ]]; then
  ensure_directory "$REPO_ROOT/${FRONTEND_ROOT}"
  ensure_directory "$REPO_ROOT/${BACKEND_ROOT}"
  printf "# Frontend Scaffold\n\n%s\n" "$FRONTEND_COMMAND" > "$REPO_ROOT/${FRONTEND_ROOT}/scaffold.todo.md"
  printf "# Backend Scaffold\n\n%s\n" "$BACKEND_COMMAND" > "$REPO_ROOT/${BACKEND_ROOT}/scaffold.todo.md"
fi

echo "Scaffold execution plan prepared: $OUTPUT_PLAN"
echo "Frontend command: $FRONTEND_COMMAND"
echo "Backend command : $BACKEND_COMMAND"
