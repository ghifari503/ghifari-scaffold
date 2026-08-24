#!/usr/bin/env sh
set -eu
expected='https://github.com/odonplay/odonplay-agent-scaffold'
alternate='git@github.com:odonplay/odonplay-agent-scaffold'
alternate_ssh='ssh://git@github.com/odonplay/odonplay-agent-scaffold'
expected_root='e:/www/project-scaffold'
root="$(git rev-parse --show-toplevel)"
normalized_root="$(printf '%s' "$root" | tr '\\\\' '/' | tr '[:upper:]' '[:lower:]')"
normalized_root="${normalized_root%/}"
if [ "$normalized_root" != "$expected_root" ]; then
  echo "Blocked: Master Scaffold updates may originate only from E:/www/project-scaffold." >&2
  echo "Actual repository root: $root" >&2
  echo "Master Framework roots and Working Projects must not commit or push to the Master Scaffold origin." >&2
  exit 1
fi
case "$root" in */development/*) echo "Blocked: target projects must use their own repository." >&2; exit 1;; esac
if [ -f "$root/.project-scaffold.json" ]; then
  echo "Blocked: Master Framework / Project Scaffold local context is not the canonical Master Scaffold commit root." >&2
  echo "Run scaffold maintenance from the canonical Master Scaffold local path." >&2
  exit 1
fi
remote="$(git -C "$root" config --get remote.origin.url || true)"
remote="${remote%/}"
remote="${remote%.git}"
if [ "$remote" != "$expected" ] && [ "$remote" != "$alternate" ] && [ "$remote" != "$alternate_ssh" ]; then
  echo "Blocked: scaffold maintenance requires the official odonplay-agent-scaffold origin." >&2
  echo "Expected: $expected" >&2
  echo "Actual: ${remote:-<none>}" >&2
  exit 1
fi
