# Claude Runtime Files

This folder contains Claude-specific configuration, agents, memories, model-routing configuration, and a synchronized skills mirror.

- Read root `AGENTS.md` for the shared operational rules.
- `skills/` must remain synchronized with `.codex/skills/`.
- `agents/` contains bounded Claude-specific roles.
- `model-routing.json` supports the Claude Code VS Code routing policy.
- `MEMORY.md` and `memories/` are Claude compatibility/context files, not a replacement for scaffold memory under `artifacts/memory/`.

Do not duplicate root policies or command menus here. Run `scripts/check-skills.ps1` after changes that affect skills.
