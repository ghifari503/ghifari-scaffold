#!/usr/bin/env bash
set -euo pipefail

KIND="${1:-}"
NAME="${2:-}"

if [[ -z "$KIND" || -z "$NAME" ]]; then
  echo "[error] Usage: bash scripts/create-development-unit.sh <frontend-page|backend-unit|backend-module|backend-service|shared-package> <name>" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURRENT_PHASE_PATH="$REPO_ROOT/docs/CURRENT_PHASE.md"

get_value() {
  local key="$1"
  python - "$CURRENT_PHASE_PATH" "$key" <<'PY'
import re
import sys
from pathlib import Path

content = Path(sys.argv[1]).read_text()
key = sys.argv[2]
match = re.search(rf"^- {re.escape(key)}: `(.*)`$", content, re.MULTILINE)
print(match.group(1) if match else "")
PY
}

FRONTEND_ROOT="$(get_value active_frontend_root)"
BACKEND_ROOT="$(get_value active_backend_root)"
SHARED_CONTRACTS_ROOT="$(get_value active_shared_contracts_root)"

case "$KIND" in
  frontend-page)
    if [[ -z "$FRONTEND_ROOT" || "$FRONTEND_ROOT" == "not_selected" ]]; then
      echo "[error] Active frontend root not set. Register the route first." >&2
      exit 1
    fi
    TARGET_PATH="$REPO_ROOT/$FRONTEND_ROOT/$NAME"
    ;;
  backend-unit|backend-module|backend-service)
    if [[ -z "$BACKEND_ROOT" || "$BACKEND_ROOT" == "not_selected" ]]; then
      echo "[error] Active backend root not set. Register the route first." >&2
      exit 1
    fi
    TARGET_PATH="$REPO_ROOT/$BACKEND_ROOT/$NAME"
    ;;
  shared-package)
    if [[ -z "$SHARED_CONTRACTS_ROOT" || "$SHARED_CONTRACTS_ROOT" == "not_selected" ]]; then
      echo "[error] Active shared contracts root not set. Register the route first." >&2
      exit 1
    fi
    TARGET_PATH="$REPO_ROOT/$SHARED_CONTRACTS_ROOT/$NAME"
    ;;
  *)
    echo "[error] Invalid kind: $KIND" >&2
    exit 1
    ;;
esac

mkdir -p "$TARGET_PATH"
: > "$TARGET_PATH/.gitkeep"

echo "Development unit created."
echo "Kind             : $KIND"
echo "Name             : $NAME"
echo "Target path      : $TARGET_PATH"
