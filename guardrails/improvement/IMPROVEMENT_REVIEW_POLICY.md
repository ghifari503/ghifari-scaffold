# Improvement Review Policy

This document defines the behavior for the commands:

- `improve`
- `improve skill`
- `cek skill` (delegates to `guardrails/system/SKILL_CHECK_POLICY.md`)

## Command: improve

Goals:
- review the active Claude/Codex runtime documentation and structure
- find improvement opportunities that make the process easier
- ensure proposals are safe for the current project

Review sources:
- `AGENTS.md`
- `CLAUDE.md`
- `README.md`
- `artifacts/operations/WORKFLOW_STATE.md`
- `artifacts/operations/CURRENT_PHASE.md`
- `guardrails/system/SKILL_CATALOG.md`
- `guardrails/development/AUTO_RUN_POLICY.md`
- `.codex/skills/`
- `.claude/skills/`

Required output:
- current pain points
- opportunity list
- risk check
- proposed action plan
- explicit approval question to the founder

Rules:
- do not apply changes immediately
- produce the action plan first
- only propose changes that:
  - make the process easier
  - are safe for the active workflow
  - do not break Claude/Codex compatibility

## Command: improve skill

Goals:
- evaluate skills against project history and real project needs
- detect skills that are too generic, have weak triggers, are placeholders, or are out of sync

Review sources:
- `artifacts/operations/SESSION_LOG.md`
- `artifacts/improvement/LEARNINGS.md`
- `artifacts/architecture/DECISION_LOG.md`
- `guardrails/system/SKILL_CATALOG.md`
- `.codex/skills/*/SKILL.md`
- `.claude/skills/*/SKILL.md`

Required output:
- target skill
- issues found
- improvement recommendation
- workflow impact
- approval question to the founder

Rules:
- skill improvement must be based on real project needs
- do not rewrite skills broadly without approval
- prioritize small changes that improve clarity, trigger accuracy, and safety

