#!/usr/bin/env sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VALIDATOR="$REPO_ROOT/scripts/validate-documentation-sync.ps1"
ROOT_ARGUMENT="$REPO_ROOT"

if command -v cygpath >/dev/null 2>&1; then
  VALIDATOR=$(cygpath -w "$VALIDATOR")
  ROOT_ARGUMENT=$(cygpath -w "$ROOT_ARGUMENT")
elif command -v wslpath >/dev/null 2>&1; then
  VALIDATOR=$(wslpath -w "$VALIDATOR")
  ROOT_ARGUMENT=$(wslpath -w "$ROOT_ARGUMENT")
fi

if command -v pwsh >/dev/null 2>&1; then
  exec pwsh -NoProfile -File "$VALIDATOR" -RepositoryRoot "$ROOT_ARGUMENT" "$@"
fi

if command -v powershell >/dev/null 2>&1; then
  exec powershell -NoProfile -File "$VALIDATOR" -RepositoryRoot "$ROOT_ARGUMENT" "$@"
fi

if command -v powershell.exe >/dev/null 2>&1; then
  exec powershell.exe -NoProfile -File "$VALIDATOR" -RepositoryRoot "$ROOT_ARGUMENT" "$@"
fi

echo "DOCUMENTATION_SYNC_INVALID: PowerShell is required to run the canonical validator." >&2
exit 1
