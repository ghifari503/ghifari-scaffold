#!/usr/bin/env bash
set -euo pipefail

canonical_root=".codex/skills"
antigravity_root=".agents/skills"
[[ -d "$canonical_root" && -d "$antigravity_root" ]] || { echo "Antigravity or Codex skill root is missing." >&2; exit 1; }

canonical_manifest="$(mktemp)"
antigravity_manifest="$(mktemp)"
trap 'rm -f "$canonical_manifest" "$antigravity_manifest"' EXIT

(cd "$canonical_root" && find . -type f -print0 | sort -z | xargs -0 sha256sum) > "$canonical_manifest"
(cd "$antigravity_root" && find . -type f -print0 | sort -z | xargs -0 sha256sum) > "$antigravity_manifest"
diff -u "$canonical_manifest" "$antigravity_manifest"
echo "[ok] Antigravity skill mirror matches Codex."
