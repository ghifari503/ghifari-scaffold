# Codex Runtime Files

This folder contains Codex-specific agents, command helpers, model-routing configuration, and the canonical runtime skills mirror.

- Read root `AGENTS.md` for shared operational rules.
- `skills/` is the canonical source for synchronized runtime skills; `.claude/skills/` and `.agents/skills/` mirror it.
- `agents/` contains bounded Codex-specific roles.
- `commands/` contains Codex command helpers.
- `model-routing.json` supports the Codex routing policy.

Do not duplicate root policies or command menus here. Run `scripts/check-skills.ps1` and `scripts/check-antigravity-skills.ps1` after skill changes.
