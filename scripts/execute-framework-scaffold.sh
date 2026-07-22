#!/usr/bin/env bash
set -euo pipefail

BACKEND_UNIT_NAME=""
FRONTEND_ONLY="no"
BACKEND_ONLY="no"
EXECUTE="no"

for arg in "$@"; do
  case "$arg" in
    --frontend-only) FRONTEND_ONLY="yes" ;;
    --backend-only) BACKEND_ONLY="yes" ;;
    --execute) EXECUTE="yes" ;;
    --backend-unit=*) BACKEND_UNIT_NAME="${arg#*=}" ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CURRENT_PHASE="$REPO_ROOT/docs/CURRENT_PHASE.md"
FRAMEWORK_DECISION="$REPO_ROOT/docs/artifacts/architecture/framework-decision.md"
PLAN_PATH="$REPO_ROOT/docs/artifacts/architecture/scaffold-execution-plan.md"

get_line_value() {
  local file="$1"
  local key="$2"
  local line
  line="$(grep -E "^- ${key}:" "$file" | head -n 1 || true)"
  line="${line#- $key: }"
  line="${line//\`/}"
  echo "$line"
}

replace_or_append_line() {
  local file="$1"
  local key="$2"
  local value="$3"
  if grep -qE "^- ${key}:" "$file"; then
    sed -i "s|^- ${key}:.*$|- ${key}: ${value}|g" "$file"
  else
    printf "\n- %s: %s\n" "$key" "$value" >> "$file"
  fi
}

ARCHITECTURE_STYLE="$(get_line_value "$CURRENT_PHASE" "architecture_style")"
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

RESOLVED_BACKEND_ROOT="$BACKEND_ROOT"
if [[ -n "$BACKEND_UNIT_NAME" ]]; then
  RESOLVED_BACKEND_ROOT="$BACKEND_ROOT/$BACKEND_UNIT_NAME"
elif [[ "$ARCHITECTURE_STYLE" == "microservice" ]]; then
  echo "[warn] No backend unit name provided. Using the registered backend root as-is." >&2
fi

FRONTEND_KEY="${FRONTEND_FRAMEWORK}|${FRONTEND_RUNTIME}|${PACKAGE_MANAGER}"
BACKEND_KEY="${BACKEND_FRAMEWORK}|${BACKEND_RUNTIME}|${PACKAGE_MANAGER}"
STACK_SIGNATURE="${DEVELOPMENT_ROUTE}|${FRONTEND_FRAMEWORK}|${FRONTEND_RUNTIME}|${BACKEND_FRAMEWORK}|${BACKEND_RUNTIME}|${PACKAGE_MANAGER}|${PRIMARY_DATABASE}|${DATABASE_ACCESS_LAYER}"

case "$FRONTEND_KEY" in
  "react|vite|pnpm") FRONTEND_COMMAND="pnpm create vite $FRONTEND_ROOT --template react-ts" ;;
  "react|vite|npm") FRONTEND_COMMAND="npm create vite@latest $FRONTEND_ROOT -- --template react-ts" ;;
  "vue|vite|pnpm") FRONTEND_COMMAND="pnpm create vue@latest $FRONTEND_ROOT" ;;
  "vue|vite|npm") FRONTEND_COMMAND="npm create vue@latest $FRONTEND_ROOT" ;;
  "nextjs|next-runtime|pnpm") FRONTEND_COMMAND="pnpm create next-app $FRONTEND_ROOT --ts --app" ;;
  "nextjs|next-runtime|npm") FRONTEND_COMMAND="npx create-next-app@latest $FRONTEND_ROOT --ts --app" ;;
  "nuxt|nuxt-runtime|pnpm") FRONTEND_COMMAND="pnpm dlx nuxi@latest init $FRONTEND_ROOT" ;;
  "nuxt|nuxt-runtime|npm") FRONTEND_COMMAND="npx nuxi@latest init $FRONTEND_ROOT" ;;
  *) FRONTEND_COMMAND="" ;;
esac

case "$BACKEND_KEY" in
  "nestjs|nodejs|pnpm") BACKEND_COMMAND="pnpm dlx @nestjs/cli new $RESOLVED_BACKEND_ROOT" ;;
  "nestjs|nodejs|npm") BACKEND_COMMAND="npx @nestjs/cli new $RESOLVED_BACKEND_ROOT" ;;
  "express|nodejs|pnpm") BACKEND_COMMAND="mkdir -p $RESOLVED_BACKEND_ROOT && cd $RESOLVED_BACKEND_ROOT && pnpm init" ;;
  "fastify|nodejs|pnpm") BACKEND_COMMAND="mkdir -p $RESOLVED_BACKEND_ROOT && cd $RESOLVED_BACKEND_ROOT && pnpm init" ;;
  "fastapi|python|poetry") BACKEND_COMMAND="mkdir -p $RESOLVED_BACKEND_ROOT && cd $RESOLVED_BACKEND_ROOT && poetry init" ;;
  "fastapi|python|pip") BACKEND_COMMAND="mkdir -p $RESOLVED_BACKEND_ROOT && cd $RESOLVED_BACKEND_ROOT && python -m venv .venv" ;;
  "django|python|pip") BACKEND_COMMAND="django-admin startproject app $RESOLVED_BACKEND_ROOT" ;;
  "laravel|php|composer") BACKEND_COMMAND="composer create-project laravel/laravel $RESOLVED_BACKEND_ROOT" ;;
  *) BACKEND_COMMAND="" ;;
esac

RUN_FRONTEND="yes"
RUN_BACKEND="yes"
if [[ "$BACKEND_ONLY" == "yes" ]]; then RUN_FRONTEND="no"; fi
if [[ "$FRONTEND_ONLY" == "yes" ]]; then RUN_BACKEND="no"; fi

if [[ "$RUN_FRONTEND" == "yes" && -z "$FRONTEND_COMMAND" ]]; then
  echo "No executable frontend scaffold command mapped for current stack."
  exit 1
fi

if [[ "$RUN_BACKEND" == "yes" && -z "$BACKEND_COMMAND" ]]; then
  echo "No executable backend scaffold command mapped for current stack."
  exit 1
fi

if [[ ! -f "$PLAN_PATH" ]]; then
  printf "# Scaffold Execution Plan\n" > "$PLAN_PATH"
fi

replace_or_append_line "$PLAN_PATH" "execution_mode" "$( [[ "$EXECUTE" == "yes" ]] && echo executed || echo dry_run )"
replace_or_append_line "$PLAN_PATH" "resolved_backend_root" "$RESOLVED_BACKEND_ROOT"
replace_or_append_line "$PLAN_PATH" "frontend_execution_selected" "$( [[ "$RUN_FRONTEND" == "yes" ]] && echo yes || echo no )"
replace_or_append_line "$PLAN_PATH" "backend_execution_selected" "$( [[ "$RUN_BACKEND" == "yes" ]] && echo yes || echo no )"
replace_or_append_line "$PLAN_PATH" "stack_signature" "$STACK_SIGNATURE"
replace_or_append_line "$PLAN_PATH" "dry_run_status" "completed"
replace_or_append_line "$PLAN_PATH" "dry_run_ran_at" "$(date -Iseconds)"
replace_or_append_line "$PLAN_PATH" "dry_run_stack_signature" "$STACK_SIGNATURE"
if [[ "$EXECUTE" == "yes" ]]; then
  replace_or_append_line "$PLAN_PATH" "real_execute_status" "completed"
  replace_or_append_line "$PLAN_PATH" "real_execute_ran_at" "$(date -Iseconds)"
fi

echo "Scaffold execution mode: $( [[ "$EXECUTE" == "yes" ]] && echo EXECUTE || echo DRY RUN )"
[[ "$RUN_FRONTEND" == "yes" ]] && echo "Frontend command: $FRONTEND_COMMAND"
[[ "$RUN_BACKEND" == "yes" ]] && echo "Backend command : $BACKEND_COMMAND"

if [[ "$EXECUTE" != "yes" ]]; then
  echo "No commands were executed. Re-run with --execute to run them."
  exit 0
fi

cd "$REPO_ROOT"
[[ "$RUN_FRONTEND" == "yes" ]] && eval "$FRONTEND_COMMAND"
[[ "$RUN_BACKEND" == "yes" ]] && eval "$BACKEND_COMMAND"

echo "Framework scaffold execution finished."
