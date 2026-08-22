#!/usr/bin/env sh
set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SCRIPT="$REPO_ROOT/scripts/update-scaffold-project.ps1"
ROOT_ARGUMENT="$REPO_ROOT"

if command -v cygpath >/dev/null 2>&1; then
  SCRIPT=$(cygpath -w "$SCRIPT")
  ROOT_ARGUMENT=$(cygpath -w "$ROOT_ARGUMENT")
elif command -v wslpath >/dev/null 2>&1; then
  SCRIPT=$(wslpath -w "$SCRIPT")
  ROOT_ARGUMENT=$(wslpath -w "$ROOT_ARGUMENT")
fi

if command -v pwsh >/dev/null 2>&1; then
  exec pwsh -NoProfile -File "$SCRIPT" -RepositoryRoot "$ROOT_ARGUMENT" "$@"
fi
if command -v powershell >/dev/null 2>&1; then
  exec powershell -NoProfile -File "$SCRIPT" -RepositoryRoot "$ROOT_ARGUMENT" "$@"
fi
if command -v powershell.exe >/dev/null 2>&1; then
  exec powershell.exe -NoProfile -File "$SCRIPT" -RepositoryRoot "$ROOT_ARGUMENT" "$@"
fi

echo 'SCAFFOLD_ADOPTION_BLOCKED: PowerShell is required.' >&2
exit 1
