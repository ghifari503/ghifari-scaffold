#!/usr/bin/env bash
set -euo pipefail

SILENT=""
for arg in "$@"; do
  case "$arg" in
    --silent)
      SILENT="--silent"
      ;;
  esac
done

bash "$(dirname "$0")/sync-skills.sh" --target=all ${SILENT:+--silent}

collect_skills() {
  local runtime="$1"
  local dir="./.${runtime}/skills"

  if [[ ! -d "$dir" ]]; then
    return
  fi

  find "$dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -u
}

copy_missing_skills() {
  local source_runtime="$1"
  local target_runtime="$2"
  local source_dir="./.${source_runtime}/skills"
  local target_dir="./.${target_runtime}/skills"
  local copied=()

  [[ ! -d "$source_dir" || ! -d "$target_dir" ]] && return 0

  while IFS= read -r folder; do
    [[ -z "$folder" ]] && continue
    if [[ ! -d "$target_dir/$folder" ]]; then
      cp -R "$source_dir/$folder" "$target_dir/$folder"
      copied+=("$folder")
    fi
  done < <(find "$source_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -u)

  printf '%s\n' "${copied[@]}"
}

mapfile -t CODEX < <(collect_skills "codex")
mapfile -t CLAUDE < <(collect_skills "claude")

UNPREFIXED="$(printf '%s\n' "${CODEX[@]}" "${CLAUDE[@]}" | grep -v '__' || true)"
if [[ -n "$UNPREFIXED" ]]; then
  echo "Skill check failed: unprefixed skill folders remain." >&2
  exit 1
fi

mapfile -t COPIED_TO_CODEX < <(copy_missing_skills "claude" "codex")
mapfile -t COPIED_TO_CLAUDE < <(copy_missing_skills "codex" "claude")

if [[ ${#COPIED_TO_CODEX[@]} -gt 0 || ${#COPIED_TO_CLAUDE[@]} -gt 0 ]]; then
  bash "$(dirname "$0")/sync-skills.sh" --target=all ${SILENT:+--silent}
fi

mapfile -t CODEX < <(collect_skills "codex")
mapfile -t CLAUDE < <(collect_skills "claude")
mapfile -t SHARED < <(comm -12 <(printf '%s\n' "${CODEX[@]}" | sort) <(printf '%s\n' "${CLAUDE[@]}" | sort))
mapfile -t CODEX_ONLY < <(comm -23 <(printf '%s\n' "${CODEX[@]}" | sort) <(printf '%s\n' "${CLAUDE[@]}" | sort))
mapfile -t CLAUDE_ONLY < <(comm -13 <(printf '%s\n' "${CODEX[@]}" | sort) <(printf '%s\n' "${CLAUDE[@]}" | sort))

if [[ ${#CODEX_ONLY[@]} -gt 0 || ${#CLAUDE_ONLY[@]} -gt 0 ]]; then
  echo "Skill check failed: runtime skill lists are still out of sync." >&2
  exit 1
fi

echo "Skill check complete."
echo "Catalog refreshed: guardrails/system/SKILL_CATALOG.md"
echo "Codex skill folders : ${#CODEX[@]}"
echo "Claude skill folders: ${#CLAUDE[@]}"
echo "Shared skills       : ${#SHARED[@]}"
echo "Codex-only skills   : ${#CODEX_ONLY[@]}"
echo "Claude-only skills  : ${#CLAUDE_ONLY[@]}"
echo "Copied to codex     : ${#COPIED_TO_CODEX[@]}"
echo "Copied to claude    : ${#COPIED_TO_CLAUDE[@]}"

if [[ ${#COPIED_TO_CODEX[@]} -gt 0 ]]; then
  echo "Added into codex    : $(IFS=', '; echo "${COPIED_TO_CODEX[*]}")"
fi

if [[ ${#COPIED_TO_CLAUDE[@]} -gt 0 ]]; then
  echo "Added into claude   : $(IFS=', '; echo "${COPIED_TO_CLAUDE[*]}")"
fi
