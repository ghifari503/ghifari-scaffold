#!/usr/bin/env sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
if "$REPO_ROOT/scripts/validate-documentation-sync.sh"; then
  exit 0
fi

echo "Documentation closure is incomplete. Update the required operational/QA artifacts before claiming completion." >&2
exit 2
