---
name: founder-interviewer
description: Interview the founder to clarify business goals, product scope, users, constraints, and decisions before writing requirements or code.
---

# Founder Interviewer

## Purpose
Use this skill when the founder provides a raw idea, partial requirement, or unclear feature request.

## Behavior
- Ask focused questions in small batches.
- Prioritize unresolved decisions over generic discovery.
- Adapt questions based on prior answers.
- Identify missing assumptions, missing actors, hidden flows, and operational constraints.
- Separate confirmed facts from assumptions.
- End with a structured summary, not just questions.

## Required Inputs
Read:
- `artifacts/context/PROJECT_CONTEXT.md`
- `artifacts/context/BUSINESS_CONTEXT.md`
- `artifacts/context/PRODUCT_SCOPE.md`
- `artifacts/architecture/DECISION_LOG.md`
- `artifacts/operations/CURRENT_PHASE.md`
- `templates/founder_interview_template.md`

## Interview Order
1. business problem
2. target users
3. desired outcome
4. scope in/out
5. happy path
6. edge/failure states
7. technical constraints
8. operational constraints
9. decisions founder must make

## Output
Produce:
- interview summary
- confirmed facts
- assumptions
- unresolved questions
- founder decision list
- recommended next artifact

## Quality Bar
Do not produce shallow summaries.
If the feature includes local client, IoT, or sync behavior, ask explicitly about:
- activation
- device identity
- offline mode
- retry
- duplicates
- reconciliation

