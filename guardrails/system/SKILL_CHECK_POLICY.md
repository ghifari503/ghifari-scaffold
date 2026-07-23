# Skill Check Policy

This document defines the behavior for the command:

- `cek skill`
- `check skill`

## Goal

Keep runtime skill folders and the shared skill catalog consistent across:

- `.codex/skills/`
- `.claude/skills/`
- `.agents/skills/` (Antigravity runtime mirror)
- `guardrails/system/SKILL_CATALOG.md`

## Required Behavior

When the founder runs `cek skill`, the runtime must:

1. Scan `.codex/skills/`, `.claude/skills/`, and `.agents/skills/`.
2. Detect skill folders that were added without the required `category__skill-name` prefix.
3. Rename those folders using the category heuristic from `scripts/sync-skills.ps1` or `scripts/sync-skills.sh`.
4. Mirror missing skill folders so `.codex/skills/`, `.claude/skills/`, and `.agents/skills/` end with the same skill list and file content.
5. Refresh `guardrails/system/SKILL_CATALOG.md`.
6. Verify that both runtime lists now match exactly.
7. Report:
   - shared skills
   - copied into codex
   - copied into claude
   - remaining runtime synchronization gaps if the sync fails
8. Do not overwrite an existing skill folder during runtime synchronization. If a repair would require replacing an existing folder, stop and report the conflict.
9. Do not edit product code.

## Prefix Rule

Every runtime skill folder must use this format:

`[category]__[skill-name]`

Allowed categories:

- `planning`
- `design`
- `backend`
- `frontend`
- `iot`
- `qa`
- `release`
- `system`

If a newly added folder does not use one of these prefixes, the sync script must infer the category from `SKILL.md` content and rename it before catalog refresh.

## Source Of Truth

- Runtime skill folders are the source of truth for actual skill availability.
- `cek skill` enforces runtime list synchronization by taking the union of both runtime skill folders and copying missing folders to the other runtime.
- `guardrails/system/SKILL_CATALOG.md` is the human-readable catalog generated from those folders.
- `scripts/check-skills.ps1` and `scripts/check-skills.sh` are the preferred automation entrypoints for command execution.

## Reporting

If the founder asks for a written summary artifact, use:

- `templates/skill_check_report_template.md`

Otherwise a concise chat report is enough.

## Missing Skill Discovery And Acquisition

When a required coding skill is not available locally:

1. Search the runtime-appropriate mirror (`.codex/skills/`, `.claude/skills/`, or `.agents/skills/`) and `SKILL_CATALOG.md` before searching externally.
2. Use `find-skills` to discover external candidates.
3. Validate capability fit, publisher reputation, usage signal, license, and the files included by the candidate skill.
4. An allowlisted publisher may be acquired without an additional founder approval. The default allowlist is:
   - `anthropics`
   - `vercel-labs`
   - `openai`
   - `microsoft`
   - `vuejs`
   - `vuejs-ai`
   - `antfu`
5. For a publisher outside this allowlist, show the candidate source and wait for explicit founder approval before download.
6. Install every approved external skill as a complete, normalized folder in `.codex/skills/`, `.claude/skills/`, and `.agents/skills/`. Do not install it only in a global user folder or one runtime mirror.
7. Run `cek skill` after installation. The catalog must be refreshed and both runtime folder lists must match before the new skill is used.
8. If no suitable external skill exists, use the `skill-creator` flow before coding proceeds.

`.agents/skills/` is the Antigravity runtime mirror. `.codex/skills/` remains the canonical synchronization source; none of the three runtime mirrors may drift.
