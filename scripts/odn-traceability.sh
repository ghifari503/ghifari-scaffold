#!/usr/bin/env sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
if ! command -v node >/dev/null 2>&1; then
  echo 'ODN_TRACEABILITY_BLOCKED: Node.js is required.' >&2
  exit 1
fi
exec node "$REPO_ROOT/scripts/odn-traceability.mjs" "$@"
