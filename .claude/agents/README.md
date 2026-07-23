# Claude Agents Folder

This folder contains Claude-compatible agent definitions.

Guidelines:
- Keep agent purpose aligned between `.claude/agents/` and `.codex/agents/`.
- Claude-specific model frontmatter may differ from Codex.
- Prefer updating both locations when behavior changes.

## Current Agents
- `backend-builder`: backend implementation after approved scope and open pre-coding gate.
- `code-reviewer`: code review and risk finding.
- `debugger`: debugging failed behavior.
- `frontend-builder`: frontend implementation after approved scope and open pre-coding gate.
- `flutter-builder`: Flutter/Dart implementation after approved scope and open pre-coding gate.
- `flutter-qa`: Flutter/Dart analyzer, unit/widget/integration test, platform smoke, and QA evidence work.
- `iot-builder`: IoT implementation after approved scope and open pre-coding gate.
- `memory-curator`: scaffold memory capture, recall, synchronization, pruning, and TOML/Markdown ledger maintenance.
- `qa-runner`: QA execution and evidence capture.
- `release-checker`: release readiness verification.
- `claude-routing-supervisor`: Sonnet-based classifier and bounded native-subagent router for Claude Code VS Code.
- `claude-fast-worker`: Haiku worker for isolated L0 work.
- `claude-deep-reviewer`: Opus reviewer for bounded L3 analysis or QA.
