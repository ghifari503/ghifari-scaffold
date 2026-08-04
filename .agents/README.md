# Antigravity Runtime Files

This folder contains Google Antigravity entrypoints and its synchronized skills mirror.

- `rules/` points Antigravity back to root `AGENTS.md` and the runtime policy.
- `skills/` must remain synchronized with `.codex/skills/`.
- Antigravity-specific model behavior is governed by `guardrails/system/ANTIGRAVITY_RUNTIME_POLICY.md`.

Do not place independent workflow rules here. Validate mirror parity with `scripts/check-antigravity-skills.ps1` after skill changes.
