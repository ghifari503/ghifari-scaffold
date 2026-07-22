#!/usr/bin/env bash
set -euo pipefail

ARCHITECTURE_STYLE="${1:-}"
DEVELOPMENT_ROUTE="${2:-}"
FRONTEND_ROOT="${3:-}"
BACKEND_ROOT="${4:-}"
SHARED_CONTRACTS_ROOT="${5:-}"

if [[ -z "$ARCHITECTURE_STYLE" || -z "$DEVELOPMENT_ROUTE" || -z "$FRONTEND_ROOT" || -z "$BACKEND_ROOT" || -z "$SHARED_CONTRACTS_ROOT" ]]; then
  echo "[error] Usage: bash scripts/activate-development-route.sh <monolith_modular|microservice|custom> <development_route> <frontend_root> <backend_root> <shared_contracts_root>" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURRENT_PHASE_PATH="$REPO_ROOT/docs/CURRENT_PHASE.md"
WORKFLOW_STATE_PATH="$REPO_ROOT/docs/WORKFLOW_STATE.md"
TIMESTAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

python - "$CURRENT_PHASE_PATH" "$WORKFLOW_STATE_PATH" "$ARCHITECTURE_STYLE" "$DEVELOPMENT_ROUTE" "$FRONTEND_ROOT" "$BACKEND_ROOT" "$SHARED_CONTRACTS_ROOT" "$TIMESTAMP" <<'PY'
import re
import sys
from pathlib import Path

current_phase_path = Path(sys.argv[1])
workflow_state_path = Path(sys.argv[2])
architecture_style = sys.argv[3]
development_route = sys.argv[4]
frontend_root = sys.argv[5]
backend_root = sys.argv[6]
shared_contracts_root = sys.argv[7]
timestamp = sys.argv[8]

def update(text: str, pattern: str, replacement: str) -> str:
    return re.sub(pattern, replacement, text, flags=re.MULTILINE)

current_phase = current_phase_path.read_text()
current_phase = update(current_phase, r"^- architecture_style: `.*`$", f"- architecture_style: `{architecture_style}`")
current_phase = update(current_phase, r"^- development_route: `.*`$", f"- development_route: `{development_route}`")
current_phase = update(current_phase, r"^- active_frontend_root: `.*`$", f"- active_frontend_root: `{frontend_root}`")
current_phase = update(current_phase, r"^- active_backend_root: `.*`$", f"- active_backend_root: `{backend_root}`")
current_phase = update(current_phase, r"^- active_shared_contracts_root: `.*`$", f"- active_shared_contracts_root: `{shared_contracts_root}`")
current_phase = update(current_phase, r"^- current_routes_audited: `.*`$", "- current_routes_audited: `yes`")
current_phase = update(current_phase, r"^- updated_at: `.*`$", f"- updated_at: `{timestamp}`")
current_phase_path.write_text(current_phase)

workflow_state = workflow_state_path.read_text()
workflow_state = update(workflow_state, r"^- architecture_style: `.*`$", f"- architecture_style: `{architecture_style}`")
workflow_state = update(workflow_state, r"^- development_route: `.*`$", f"- development_route: `{development_route}`")
workflow_state = update(workflow_state, r"^- active_frontend_root: `.*`$", f"- active_frontend_root: `{frontend_root}`")
workflow_state = update(workflow_state, r"^- active_backend_root: `.*`$", f"- active_backend_root: `{backend_root}`")
workflow_state = update(workflow_state, r"^- active_shared_contracts_root: `.*`$", f"- active_shared_contracts_root: `{shared_contracts_root}`")
workflow_state = update(workflow_state, r"^- current_routes_audited: `.*`$", "- current_routes_audited: `yes`")
workflow_state = update(workflow_state, r"^- active_route_status: `.*`$", "- active_route_status: `confirmed`")
workflow_state = update(workflow_state, r"^- Last Updated: `.*`$", f"- Last Updated: `{timestamp}`")
workflow_state_path.write_text(workflow_state)
PY

echo "Development route registered."
echo "Architecture style : $ARCHITECTURE_STYLE"
echo "Development route  : $DEVELOPMENT_ROUTE"
echo "Frontend root      : $FRONTEND_ROOT"
echo "Backend root       : $BACKEND_ROOT"
echo "Shared contracts   : $SHARED_CONTRACTS_ROOT"
