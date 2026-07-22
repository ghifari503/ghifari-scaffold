#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 5 ]]; then
  echo "Usage: bash scripts/activate-framework-decision.sh <frontend_framework> <backend_framework> <primary_database> <package_manager> <testing_stack> [frontend_runtime] [backend_runtime] [styling_approach] [database_access_layer] [migration_tooling] [cache_layer] [search_requirement]"
  exit 1
fi

FRONTEND_FRAMEWORK="$1"
BACKEND_FRAMEWORK="$2"
PRIMARY_DATABASE="$3"
PACKAGE_MANAGER="$4"
TESTING_STACK="$5"
FRONTEND_RUNTIME="${6:-custom}"
BACKEND_RUNTIME="${7:-custom}"
STYLING_APPROACH="${8:-other}"
DATABASE_ACCESS_LAYER="${9:-other}"
MIGRATION_TOOLING="${10:-framework-default}"
CACHE_LAYER="${11:-none}"
SEARCH_REQUIREMENT="${12:-none}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CURRENT_PHASE="$REPO_ROOT/docs/CURRENT_PHASE.md"
WORKFLOW_STATE="$REPO_ROOT/docs/WORKFLOW_STATE.md"
FRAMEWORK_DECISION="$REPO_ROOT/docs/artifacts/architecture/framework-decision.md"

get_line_value() {
  local file="$1"
  local key="$2"
  local line
  line="$(grep -E "^- ${key}:" "$file" || true)"
  line="${line#- $key: }"
  line="${line//\`/}"
  echo "$line"
}

replace_or_append_line() {
  local file="$1"
  local key="$2"
  local value="$3"

  if grep -qE "^- ${key}:" "$file"; then
    sed -i "s|^- ${key}:.*$|- ${key}: \`${value}\`|g" "$file"
  else
    printf "\n- %s: \`%s\`\n" "$key" "$value" >> "$file"
  fi
}

ARCHITECTURE_STYLE="$(get_line_value "$CURRENT_PHASE" "architecture_style")"
DEVELOPMENT_ROUTE="$(get_line_value "$CURRENT_PHASE" "development_route")"
ACTIVE_FRONTEND_ROOT="$(get_line_value "$CURRENT_PHASE" "active_frontend_root")"
ACTIVE_BACKEND_ROOT="$(get_line_value "$CURRENT_PHASE" "active_backend_root")"
ACTIVE_SHARED_CONTRACTS_ROOT="$(get_line_value "$CURRENT_PHASE" "active_shared_contracts_root")"

if [[ -z "$DEVELOPMENT_ROUTE" ]]; then
  echo "development_route is not active yet. Run activate-development-route first."
  exit 1
fi

replace_or_append_line "$CURRENT_PHASE" "framework_decision_status" "approved"
replace_or_append_line "$CURRENT_PHASE" "frontend_framework" "$FRONTEND_FRAMEWORK"
replace_or_append_line "$CURRENT_PHASE" "backend_framework" "$BACKEND_FRAMEWORK"
replace_or_append_line "$CURRENT_PHASE" "primary_database" "$PRIMARY_DATABASE"
replace_or_append_line "$CURRENT_PHASE" "database_access_layer" "$DATABASE_ACCESS_LAYER"
replace_or_append_line "$CURRENT_PHASE" "package_manager" "$PACKAGE_MANAGER"
replace_or_append_line "$CURRENT_PHASE" "testing_stack" "$TESTING_STACK"
replace_or_append_line "$CURRENT_PHASE" "app_bootstrap_allowed" "yes"

replace_or_append_line "$WORKFLOW_STATE" "framework_decision_status" "approved"
replace_or_append_line "$WORKFLOW_STATE" "frontend_framework" "$FRONTEND_FRAMEWORK"
replace_or_append_line "$WORKFLOW_STATE" "backend_framework" "$BACKEND_FRAMEWORK"
replace_or_append_line "$WORKFLOW_STATE" "primary_database" "$PRIMARY_DATABASE"
replace_or_append_line "$WORKFLOW_STATE" "database_access_layer" "$DATABASE_ACCESS_LAYER"
replace_or_append_line "$WORKFLOW_STATE" "package_manager" "$PACKAGE_MANAGER"
replace_or_append_line "$WORKFLOW_STATE" "testing_stack" "$TESTING_STACK"
replace_or_append_line "$WORKFLOW_STATE" "app_bootstrap_allowed" "yes"

NOW="$(date -Iseconds)"
cat > "$FRAMEWORK_DECISION" <<EOF
# Framework Decision

## Metadata
- created_at: \`$NOW\`
- updated_at: \`$NOW\`
- runtime: \`manual\`
- status: \`approved\`

## Route Context
- architecture_style: \`$ARCHITECTURE_STYLE\`
- development_route: \`$DEVELOPMENT_ROUTE\`
- active_frontend_root: \`$ACTIVE_FRONTEND_ROOT\`
- active_backend_root: \`$ACTIVE_BACKEND_ROOT\`
- active_shared_contracts_root: \`$ACTIVE_SHARED_CONTRACTS_ROOT\`

## Frontend Stack
- frontend_framework: \`$FRONTEND_FRAMEWORK\`
- frontend_runtime: \`$FRONTEND_RUNTIME\`
- styling_approach: \`$STYLING_APPROACH\`

## Backend Stack
- backend_framework: \`$BACKEND_FRAMEWORK\`
- backend_runtime: \`$BACKEND_RUNTIME\`

## Data Layer
- primary_database: \`$PRIMARY_DATABASE\`
- database_access_layer: \`$DATABASE_ACCESS_LAYER\`
- migration_tooling: \`$MIGRATION_TOOLING\`
- cache_layer: \`$CACHE_LAYER\`
- search_requirement: \`$SEARCH_REQUIREMENT\`

## Tooling
- package_manager: \`$PACKAGE_MANAGER\`
- testing_stack: \`$TESTING_STACK\`

## Scaffold Permission
- app_bootstrap_allowed: \`yes\`
- bootstrap_blocker: \`approved\`
EOF

echo "Framework decision activated."
echo "Frontend framework: $FRONTEND_FRAMEWORK"
echo "Backend framework: $BACKEND_FRAMEWORK"
echo "Primary database: $PRIMARY_DATABASE"
