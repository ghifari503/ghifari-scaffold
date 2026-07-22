# .codex Directory

This folder provides Codex-native compatibility without removing Claude compatibility.

- Keep existing source-of-truth assets under `.claude/` unless you explicitly migrate.
- You can gradually mirror skills into `.codex/skills/`.
- `scripts/sync-skills.sh` supports both directories.

Recommended:
- Codex reads `AGENTS.md`
- Claude reads `CLAUDE.md`
