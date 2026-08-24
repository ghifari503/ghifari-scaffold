#!/usr/bin/env sh
set -eu

root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ] || [ ! -f "$root/.project-scaffold.json" ]; then
  exit 0
fi

if ! git -C "$root" diff --cached --quiet --; then
  git -C "$root" diff --cached --name-only -z |
    git -C "$root" restore --staged --pathspec-from-file=- --pathspec-file-nul
  echo "Auto-unstaged: every staged path in the Master Framework root." >&2
fi

echo "Blocked: a Master Framework root is local, non-Git context and cannot commit or push any root-level change." >&2
echo "Commit application work only from the independent Working Project repository under development/[project-folder]." >&2
exit 1
