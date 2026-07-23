# Codex Skills Folder

This folder is optional and can be used to host Codex-specific skill variants.

This project uses a dual-runtime layout:
- `.codex/skills/` for Codex-oriented variants
- `.claude/skills/` for legacy mirrored variants

Use `powershell -ExecutionPolicy Bypass -File scripts/sync-skills.ps1 -Target codex` on Windows, or `bash scripts/sync-skills.sh --target=codex` on bash-compatible systems, after adding skills here.
