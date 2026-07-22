---
name: improve-commander
description: >
  Use this skill when the user says "improve" and wants the system to review the current
  Claude/Codex documentation, workflow, runtime rules, and project structure, then propose
  a safe improvement plan before making changes. Always use this before making broad process
  improvements, framework workflow refinements, or runtime compatibility cleanups.
---

# Improve Commander

## Purpose

Review the current system and produce an improvement action plan first.

## Read First

- `guardrails/improvement/IMPROVEMENT_REVIEW_POLICY.md`
- `AGENTS.md`
- `CLAUDE.md`
- `README.md`
- `artifacts/operations/WORKFLOW_STATE.md`
- `artifacts/operations/CURRENT_PHASE.md`
- `guardrails/system/SKILL_CATALOG.md`
- `guardrails/development/AUTO_RUN_POLICY.md`

## Required Output

Always produce:

1. Objective
2. Current State
3. Candidate Improvements
4. Safety / Compatibility Check
5. Proposed Action Plan
6. Explicit Approval Question

## Guardrails

- Do not apply improvements immediately.
- Improvements must simplify the process and remain safe for the active project.
- Preserve Claude/Codex compatibility unless founder explicitly chooses otherwise.

