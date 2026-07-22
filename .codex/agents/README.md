# Codex Agents Folder

This folder mirrors agent documentation from `.claude/agents/` for Codex-oriented runs.

Guidelines:
- Keep agent purpose aligned between `.claude/agents/` and `.codex/agents/`.
- If an agent definition is Claude-specific, document the Codex equivalent here.
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
