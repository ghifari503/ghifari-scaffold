---
name: improve-skill
description: >
  Use this skill when the user says "improve skill" and wants to improve one or more skills
  based on development history, project needs, workflow gaps, or trigger quality. Use this
  before editing skills so the system first proposes safe, targeted skill improvements and
  asks for approval.
---

# Improve Skill

## Purpose

Evaluate skills against real project needs and propose safe improvements first.

## Read First

- `guardrails/improvement/IMPROVEMENT_REVIEW_POLICY.md`
- `artifacts/operations/SESSION_LOG.md`
- `artifacts/improvement/LEARNINGS.md`
- `artifacts/architecture/DECISION_LOG.md`
- `guardrails/system/SKILL_CATALOG.md`
- relevant skill folders in `.codex/skills/` and `.claude/skills/`

## Required Output

Always produce:

1. Target Skill(s)
2. Current Problem
3. Evidence from Project History
4. Proposed Skill Improvement
5. Workflow Impact
6. Explicit Approval Question

## Guardrails

- Do not rewrite skills immediately.
- Prefer targeted improvements over broad rewrites.
- Keep Claude/Codex skill parity when both variants exist.

