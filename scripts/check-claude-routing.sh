#!/usr/bin/env bash
set -euo pipefail

node - <<'NODE'
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('.claude/model-routing.json', 'utf8'));
const settings = JSON.parse(fs.readFileSync('.claude/settings.json', 'utf8'));
const expected = { L0: 'haiku', L1: 'sonnet', L2: 'sonnet', L3: 'opus', L4: 'configured_fable_only' };

if (config.runtime !== 'claude-code-vscode' || config.defaultModel !== 'sonnet') {
  throw new Error('Claude routing config has an invalid runtime or default model.');
}
for (const [level, model] of Object.entries(expected)) {
  if (config.profiles?.[level]?.model !== model) {
    throw new Error(`Claude routing config has an invalid model for ${level}.`);
  }
}
if (settings.model !== 'sonnet') {
  throw new Error('Claude project settings must default new sessions to Sonnet.');
}
NODE

for agent in claude-routing-supervisor.md claude-fast-worker.md claude-deep-reviewer.md; do
  test -f ".claude/agents/$agent"
done

echo "Claude Code VS Code routing validation passed."
