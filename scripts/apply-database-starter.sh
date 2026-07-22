#!/usr/bin/env bash
set -euo pipefail

BACKEND_UNIT_NAME="${1:-}"
FORCE="no"
if [[ "${2:-}" == "--force" || "${1:-}" == "--force" ]]; then
  FORCE="yes"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CURRENT_PHASE="$REPO_ROOT/docs/CURRENT_PHASE.md"
FRAMEWORK_DECISION="$REPO_ROOT/docs/artifacts/architecture/framework-decision.md"

get_line_value() {
  local file="$1"
  local key="$2"
  local line
  line="$(grep -E "^- ${key}:" "$file" | head -n 1 || true)"
  line="${line#- $key: }"
  line="${line//\`/}"
  echo "$line"
}

ARCHITECTURE_STYLE="$(get_line_value "$CURRENT_PHASE" "architecture_style")"
BACKEND_ROOT="$(get_line_value "$CURRENT_PHASE" "active_backend_root")"
DATABASE_ACCESS_LAYER="$(get_line_value "$FRAMEWORK_DECISION" "database_access_layer")"

if [[ -z "$DATABASE_ACCESS_LAYER" ]]; then
  echo "database_access_layer has not been selected in the framework decision."
  exit 1
fi

RESOLVED_BACKEND_ROOT="$REPO_ROOT/$BACKEND_ROOT"
if [[ -n "$BACKEND_UNIT_NAME" && "$BACKEND_UNIT_NAME" != "--force" ]]; then
  RESOLVED_BACKEND_ROOT="$RESOLVED_BACKEND_ROOT/$BACKEND_UNIT_NAME"
elif [[ "$ARCHITECTURE_STYLE" == "microservice" ]]; then
  echo "[warn] No backend unit name provided. Using the registered backend root as-is." >&2
fi

case "$DATABASE_ACCESS_LAYER" in
  "prisma")
    SOURCE="$REPO_ROOT/templates/database/prisma/schema.prisma.example"
    TARGET="$RESOLVED_BACKEND_ROOT/prisma/schema.prisma"
    ;;
  "drizzle")
    SOURCE="$REPO_ROOT/templates/database/drizzle/schema.ts.example"
    TARGET="$RESOLVED_BACKEND_ROOT/src/db/schema.ts"
    ;;
  "sqlalchemy")
    SOURCE="$REPO_ROOT/templates/database/sqlalchemy/models.py.example"
    TARGET="$RESOLVED_BACKEND_ROOT/app/models.py"
    ;;
  "django-orm")
    SOURCE="$REPO_ROOT/templates/database/django/models.py.example"
    TARGET="$RESOLVED_BACKEND_ROOT/app/models.py"
    ;;
  "eloquent")
    SOURCE="$REPO_ROOT/templates/database/laravel/0001_create_example_table.php.example"
    TARGET="$RESOLVED_BACKEND_ROOT/database/migrations/0001_create_example_table.php"
    ;;
  "mongoose")
    SOURCE="$REPO_ROOT/templates/database/mongoose/example.model.ts"
    TARGET="$RESOLVED_BACKEND_ROOT/src/models/example.model.ts"
    ;;
  *)
    echo "No starter template configured for database_access_layer: $DATABASE_ACCESS_LAYER"
    exit 1
    ;;
esac

mkdir -p "$(dirname "$TARGET")"

if [[ -f "$TARGET" && "$FORCE" != "yes" ]]; then
  echo "Target already exists: $TARGET. Use --force to overwrite."
  exit 1
fi

cp "$SOURCE" "$TARGET"

echo "Database starter applied."
echo "Access layer: $DATABASE_ACCESS_LAYER"
echo "Target path  : $TARGET"
