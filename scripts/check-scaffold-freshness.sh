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
read_version() {
  node -e 'const fs=require("fs");const s=fs.readFileSync(process.argv[1],"utf8");const m=s.match(/^-\s*version:\s*`?([^`\r\n]+)`?\s*$/m);if(m)process.stdout.write(m[1].trim().replace(/^`|`$/g,""));' "$1" 2>/dev/null || true
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
installed_version=$(read_version "$repo_root/SCAFFOLD_VERSION.md")
updater_root="$repo_root/development/_framework-updater"
updater_status=not_installed
pending_framework_update=false
if [ -e "$updater_root/.git" ]; then
  available_version=$(read_version "$updater_root/SCAFFOLD_VERSION.md")
  state_file="$repo_root/artifacts/framework-update/STATE.json"
  if [ ! -d "$updater_root/.git" ] || [ -z "$available_version" ]; then
    updater_status=invalid_updater
    pending_framework_update=true
  elif [ ! -f "$state_file" ]; then
    updater_status=update_available
    pending_framework_update=true
  else
    installed_head=$(node -e 'const fs=require("fs");try{const v=JSON.parse(fs.readFileSync(process.argv[1],"utf8")).installed_head;if(typeof v!=="string"||!v.trim())process.exit(2);process.stdout.write(v.trim())}catch(e){process.exit(2)}' "$state_file" 2>/dev/null || printf '')
    updater_head=$(git -C "$updater_root" rev-parse HEAD 2>/dev/null || printf '')
    if [ -z "$updater_head" ]; then
      updater_status=invalid_updater
      pending_framework_update=true
    elif [ -z "$installed_head" ]; then
      updater_status=invalid_local_state
      pending_framework_update=true
    elif [ -z "$installed_version" ] || [ "$available_version" != "$installed_version" ] || [ "$updater_head" != "$installed_head" ]; then
      updater_status=update_available
      pending_framework_update=true
    else
      updater_status=current
    fi
  fi
fi

printf '%s\n' 'SCAFFOLD_FRESHNESS_OK'
printf 'git_head=%s\n' "$git_head"
printf 'fingerprint=%s\n' "$fingerprint"
printf '%s\n' 'network_action=none'
printf 'framework_updater_status=%s\n' "$updater_status"
printf 'pending_framework_update=%s\n' "$pending_framework_update"
printf '%b' "$sources" | while IFS= read -r entry; do
  [ -n "$entry" ] && printf 'source=%s\n' "$entry"
done
