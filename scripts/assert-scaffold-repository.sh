#!/usr/bin/env sh
set -eu
expected='https://github.com/odonplay/odonplay-agent-scaffold'
alternate='git@github.com:odonplay/odonplay-agent-scaffold'
alternate_ssh='ssh://git@github.com/odonplay/odonplay-agent-scaffold'
root="$(git rev-parse --show-toplevel)"
case "$root" in */development/*) echo "Blocked: target projects must use their own repository." >&2; exit 1;; esac
remote="$(git -C "$root" config --get remote.origin.url || true)"
remote="${remote%/}"
remote="${remote%.git}"
if [ "$remote" != "$expected" ] && [ "$remote" != "$alternate" ] && [ "$remote" != "$alternate_ssh" ]; then
  echo "Blocked: scaffold maintenance requires the official odonplay-agent-scaffold origin." >&2
  echo "Expected: $expected" >&2
  echo "Actual: ${remote:-<none>}" >&2
  exit 1
fi
