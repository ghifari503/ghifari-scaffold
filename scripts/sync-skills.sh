#!/usr/bin/env bash
# sync-skills.sh - normalize skill prefixes and regenerate the runtime catalog
# Usage:
#   bash scripts/sync-skills.sh [--silent] [--target=auto|claude|codex|all]

set -euo pipefail

TARGET="auto"
SILENT=""

for arg in "$@"; do
  case "$arg" in
    --silent)
      SILENT="--silent"
      ;;
    --target=*)
      TARGET="${arg#*=}"
      ;;
  esac
done

CATALOG_FILE="./guardrails/system/SKILL_CATALOG.md"
declare -A RUNTIME_DIRS=(
  [codex]="./.codex/skills"
  [claude]="./.claude/skills"
)

declare -A CATEGORIES=(
  [planning]="Planning Phase"
  [design]="Design Phase"
  [backend]="Backend Phase"
  [frontend]="Frontend Phase"
  [iot]="IoT Phase"
  [qa]="QA & Review Phase"
  [release]="Release Phase"
  [system]="System & Meta"
)

EXTRA_FRONTEND_NAMES=("flutter-builder" "flutter-qa")
EXTRA_FRONTEND_CODEX_PATHS=(".codex/agents/flutter-builder.md" ".codex/agents/flutter-qa.md")
EXTRA_FRONTEND_CLAUDE_PATHS=(".claude/agents/flutter-builder.md" ".claude/agents/flutter-qa.md")
EXTRA_FRONTEND_DESCRIPTIONS=(
  "Flutter/Dart implementation agent for existing projects after intake, impact scan, approved scope, allowed write paths, and open pre-coding gate."
  "Flutter/Dart QA agent for analyzer, unit tests, widget tests, integration tests, platform smoke checks, and evidence capture."
)

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
  if [[ -z "$SILENT" ]]; then
    echo -e "${GREEN}[ok]${NC} $1"
  fi
}

error() {
  echo -e "${RED}[error]${NC} $1" >&2
}

detect_category() {
  local skill_path="$1"
  local skill_md="${skill_path}/SKILL.md"
  local skill_name
  skill_name="$(basename "$skill_path")"

  case "$skill_name" in
    better-auth-security-best-practices|security-review)
      echo "qa"
      return
      ;;
    find-skills|handoff)
      echo "system"
      return
      ;;
    improve-codebase-architecture)
      echo "planning"
      return
      ;;
    laravel-specialist)
      echo "backend"
      return
      ;;
    vue|vue-best-practices)
      echo "frontend"
      return
      ;;
    web-design-guidelines)
      echo "design"
      return
      ;;
  esac

  if [[ ! -f "$skill_md" ]]; then
    echo "system"
    return
  fi

  local content
  content="$(head -50 "$skill_md" | tr '[:upper:]' '[:lower:]')"

  if echo "$content" | grep -qE "review|qa|test|quality|runner|playwright|cypress"; then
    echo "qa"
  elif echo "$content" | grep -qE "backend|api|database|schema|endpoint|builder"; then
    echo "backend"
  elif echo "$content" | grep -qE "frontend|component|page|react|vue|builder"; then
    echo "frontend"
  elif echo "$content" | grep -qE "release|deploy|checklist|prep"; then
    echo "release"
  elif echo "$content" | grep -qE "iot|device|firmware|sensor|sync|builder"; then
    echo "iot"
  elif echo "$content" | grep -qE "interview|requirement|flow|architect|sprint"; then
    echo "planning"
  elif echo "$content" | grep -qE "design|layout|wireframe|complete"; then
    echo "design"
  else
    echo "system"
  fi
}

skill_description() {
  local skill_dir="$1"
  local skill_md="${skill_dir}/SKILL.md"

  if [[ ! -f "$skill_md" ]]; then
    return
  fi

  local desc
  desc="$(grep -m1 '^description:' "$skill_md" | sed 's/^description:[[:space:]]*//' || true)"
  if [[ -n "$desc" ]]; then
    printf '%s' "$desc"
    return
  fi

  desc="$(grep -m1 '^# ' "$skill_md" | sed 's/^# //' || true)"
  if [[ -n "$desc" ]]; then
    printf '%s' "$desc"
  fi
}

selected_runtime_keys() {
  case "$TARGET" in
    codex)
      [[ -d "${RUNTIME_DIRS[codex]}" ]] && echo "codex"
      ;;
    claude)
      [[ -d "${RUNTIME_DIRS[claude]}" ]] && echo "claude"
      ;;
    all)
      [[ -d "${RUNTIME_DIRS[codex]}" ]] && echo "codex"
      [[ -d "${RUNTIME_DIRS[claude]}" ]] && echo "claude"
      ;;
    auto)
      if [[ -d "${RUNTIME_DIRS[codex]}" ]]; then
        echo "codex"
      elif [[ -d "${RUNTIME_DIRS[claude]}" ]]; then
        echo "claude"
      fi
      ;;
    *)
      ;;
  esac
}

normalize_runtime_dir() {
  local runtime="$1"
  local skills_dir="$2"
  local renamed=0

  shopt -s nullglob
  for folder in "$skills_dir"/*/; do
    local folder_name="${folder%/}"
    folder_name="${folder_name##*/}"

    if [[ "$folder_name" == .* ]] || [[ "$folder_name" == *"__"* ]]; then
      continue
    fi

    local category
    category="$(detect_category "${skills_dir}/${folder_name}")"
    local new_name="${category}__${folder_name}"
    mv "${skills_dir}/${folder_name}" "${skills_dir}/${new_name}"
    log "${runtime} registered: ${folder_name} -> ${new_name}"
    renamed=$((renamed + 1))
  done
  shopt -u nullglob

  printf '%s' "$renamed"
}

declare -A REC_CATEGORY=()
declare -A REC_NAME=()
declare -A REC_CODEX_PATH=()
declare -A REC_CLAUDE_PATH=()
declare -A REC_DESCRIPTION=()
declare -A REC_STATUS=()

add_record() {
  local category="$1"
  local name="$2"
  local runtime="$3"
  local path="$4"
  local description="$5"
  local status="$6"

  if [[ -z "${CATEGORIES[$category]+x}" ]]; then
    category="system"
  fi

  local key="${category}|${name}"
  REC_CATEGORY["$key"]="$category"
  REC_NAME["$key"]="$name"

  if [[ "$runtime" == "codex" ]]; then
    REC_CODEX_PATH["$key"]="$path"
  elif [[ "$runtime" == "claude" ]]; then
    REC_CLAUDE_PATH["$key"]="$path"
  fi

  if [[ -n "$description" && -z "${REC_DESCRIPTION[$key]:-}" ]]; then
    REC_DESCRIPTION["$key"]="$description"
  fi

  if [[ -n "$status" && -z "${REC_STATUS[$key]:-}" ]]; then
    REC_STATUS["$key"]="$status"
  fi
}

mapfile -t SELECTED_RUNTIMES < <(selected_runtime_keys)
if [[ ${#SELECTED_RUNTIMES[@]} -eq 0 ]]; then
  error "No skills directory found for target '$TARGET'"
  exit 1
fi

TOTAL_RENAMED=0
for runtime in "${SELECTED_RUNTIMES[@]}"; do
  count="$(normalize_runtime_dir "$runtime" "${RUNTIME_DIRS[$runtime]}")"
  TOTAL_RENAMED=$((TOTAL_RENAMED + count))
done

for runtime in "${SELECTED_RUNTIMES[@]}"; do
  skills_dir="${RUNTIME_DIRS[$runtime]}"
  shopt -s nullglob
  for folder in "$skills_dir"/*/; do
    folder_name="${folder%/}"
    folder_name="${folder_name##*/}"

    [[ "$folder_name" == .* ]] && continue
    [[ "$folder_name" != *"__"* ]] && continue

    category="${folder_name%%__*}"
    name="${folder_name#*__}"
    description="$(skill_description "${skills_dir}/${folder_name}")"
    status=""
    [[ ! -f "${skills_dir}/${folder_name}/SKILL.md" ]] && status="Placeholder (no SKILL.md yet)"

    add_record "$category" "$name" "$runtime" ".${runtime}/skills/${folder_name}/" "$description" "$status"
  done
  shopt -u nullglob
done

for i in "${!EXTRA_FRONTEND_NAMES[@]}"; do
  name="${EXTRA_FRONTEND_NAMES[$i]}"
  codex_path="${EXTRA_FRONTEND_CODEX_PATHS[$i]}"
  claude_path="${EXTRA_FRONTEND_CLAUDE_PATHS[$i]}"
  description="${EXTRA_FRONTEND_DESCRIPTIONS[$i]}"

  [[ -f "$codex_path" ]] && add_record "frontend" "$name" "codex" "$codex_path" "$description" ""
  [[ -f "$claude_path" ]] && add_record "frontend" "$name" "claude" "$claude_path" "$description" ""
done

{
  echo "# Skill Catalog"
  echo
  echo "Comprehensive index of all available skills, organized by workflow phase."
  echo
  echo "---"
  echo
  echo "## Index"
  echo
  echo "> Compatibility note: this catalog is regenerated from the runtime skill folders and records availability across \`.codex\` and \`.claude\`."
  echo

  for cat in planning design backend frontend iot qa release system; do
    mapfile -t keys < <(printf '%s\n' "${!REC_CATEGORY[@]}" | awk -F'|' -v target="$cat" '$1 == target { print $0 }' | sort -t'|' -k2,2)
    [[ ${#keys[@]} -eq 0 ]] && continue

    echo "### ${CATEGORIES[$cat]}"
    for key in "${keys[@]}"; do
      echo "- [${REC_NAME[$key]}](#${cat}-${REC_NAME[$key]})"
    done
    echo
  done

  echo "---"
  echo

  for cat in planning design backend frontend iot qa release system; do
    mapfile -t keys < <(printf '%s\n' "${!REC_CATEGORY[@]}" | awk -F'|' -v target="$cat" '$1 == target { print $0 }' | sort -t'|' -k2,2)
    [[ ${#keys[@]} -eq 0 ]] && continue

    echo "## ${CATEGORIES[$cat]}"
    echo

    for key in "${keys[@]}"; do
      echo "### ${cat}_${REC_NAME[$key]}"

      availability=()
      [[ -n "${REC_CODEX_PATH[$key]:-}" ]] && availability+=("codex")
      [[ -n "${REC_CLAUDE_PATH[$key]:-}" ]] && availability+=("claude")
      printf '**Availability:** %s\n' "$(IFS=', '; echo "${availability[*]}")"

      [[ -n "${REC_CODEX_PATH[$key]:-}" ]] && printf '**Codex Path:** `%s`\n' "${REC_CODEX_PATH[$key]}"
      [[ -n "${REC_CLAUDE_PATH[$key]:-}" ]] && printf '**Claude Path:** `%s`\n' "${REC_CLAUDE_PATH[$key]}"

      if [[ -n "${REC_DESCRIPTION[$key]:-}" ]]; then
        printf '**Description:** %s\n' "${REC_DESCRIPTION[$key]}"
      elif [[ -n "${REC_STATUS[$key]:-}" ]]; then
        printf '**Status:** %s\n' "${REC_STATUS[$key]}"
      fi

      if [[ -z "${REC_CODEX_PATH[$key]:-}" || -z "${REC_CLAUDE_PATH[$key]:-}" ]]; then
        missing_runtime="claude"
        [[ -z "${REC_CODEX_PATH[$key]:-}" ]] && missing_runtime="codex"
        printf '**Parity Note:** Missing in %s runtime.\n' "$missing_runtime"
      fi

      echo
    done
  done

  echo "---"
  echo
  echo "**Generated by:** \`scripts/sync-skills.sh --target=${TARGET}\`"
} > "$CATALOG_FILE"

log "SKILL_CATALOG.md regenerated at $CATALOG_FILE"
if [[ "$TOTAL_RENAMED" -gt 0 ]]; then
  log "Summary: $TOTAL_RENAMED skill folder(s) normalized"
else
  log "Summary: no new unprefixed skill folders found"
fi
