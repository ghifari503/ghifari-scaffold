#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
hash_file() {
  if [ ! -f "$repo_root/$1" ]; then
    printf '%s\n' "Required scaffold freshness source is missing: $1" >&2
    exit 1
  fi
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$repo_root/$1" | awk '{print tolower($1)}'
  else
    shasum -a 256 "$repo_root/$1" | awk '{print tolower($1)}'
  fi
}
hash_text() {
  if command -v sha256sum >/dev/null 2>&1; then
    printf '%s' "$1" | sha256sum | awk '{print tolower($1)}'
  else
    printf '%s' "$1" | shasum -a 256 | awk '{print tolower($1)}'
  fi
}

git_head=$(git -C "$repo_root" rev-parse HEAD 2>/dev/null || printf '%s' 'not_a_git_repository')
sources=''
for path in AGENTS.md COMMANDS.md SCAFFOLD_VERSION.md artifacts/operations/WORKFLOW_STATE.md artifacts/operations/CURRENT_PHASE.md artifacts/operations/CURRENT_TASK.md artifacts/operations/SESSION_LOG.md; do
  sources="${sources}${path}=$(hash_file "$path")\n"
done
activity=artifacts/operations/AGENT_ACTIVITY_LOG.md
if [ ! -f "$repo_root/$activity" ]; then
  printf '%s\n' "Required scaffold freshness source is missing: $activity" >&2
  exit 1
fi
activity_snapshot=$(sed -n '1,14p' "$repo_root/$activity")
sources="${sources}${activity}#snapshot=$(hash_text "$activity_snapshot")\n"
fingerprint=$(hash_text "git_head=${git_head}\n${sources}")

printf '%s\n' 'SCAFFOLD_FRESHNESS_OK'
printf 'git_head=%s\n' "$git_head"
printf 'fingerprint=%s\n' "$fingerprint"
printf '%s\n' 'network_action=none'
printf '%b' "$sources" | while IFS= read -r entry; do
  [ -n "$entry" ] && printf 'source=%s\n' "$entry"
done
