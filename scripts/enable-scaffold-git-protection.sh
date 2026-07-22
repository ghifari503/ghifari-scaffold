#!/usr/bin/env sh
set -eu

root="$(git rev-parse --show-toplevel)"
if [ ! -f "$root/.githooks/pre-commit" ] || [ ! -f "$root/.githooks/pre-push" ]; then
  echo "Scaffold protection hooks are missing from $root/.githooks." >&2
  exit 1
fi

git config core.hooksPath .githooks
echo "Scaffold Git protection enabled. Commit and push project work from development/[project-folder]."
