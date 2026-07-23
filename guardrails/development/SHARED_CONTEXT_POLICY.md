# SHARED_CONTEXT_POLICY

## Purpose
Make multi-developer continuation deterministic when several developers use the same scaffold against the same target repository.

Shared context is Git-safe project continuity evidence stored inside the target repository under:

```text
development/[project-folder]/artifacts/shared/
```

This is different from scaffold-local operational state in `artifacts/operations/` and scaffold-local memory in `artifacts/memory/`.

## Required Target Repository Files

Every target repository managed through `development/[project-folder]` must maintain:

- `development/[project-folder]/artifacts/shared/PROJECT_STATE.md`
- `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`
- `development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md`
- `development/[project-folder]/artifacts/shared/AI_ROUTING_LOG.md` when Codex model routing is used
- `development/[project-folder]/artifacts/shared/handoffs/[feature]-[slice]-handoff.md` for feature or slice handoffs

Recommended when useful:

- `development/[project-folder]/artifacts/shared/DECISION_SNAPSHOT.md`

Use templates:

- `templates/shared_active_context_template.md`
- `templates/shared_contributor_log_template.md`
- `templates/shared_handoff_template.md`
- `templates/shared_project_state_template.md`

The committed default baseline is available at:

- `development/_project-template/artifacts/shared/`

During first intake or greenfield setup, copy this baseline into `development/[project-folder]/artifacts/shared/` before continuing work. The target project must be a separate Git repository that tracks this path. The scaffold root `.gitignore` must ignore the entire target project folder, including shared context.

## Mandatory Read Before Continuing Target Repo Work

Before continuing work in a target repository, every agent/runtime must read:

1. `AGENTS.md`
2. `artifacts/operations/WORKFLOW_STATE.md`
3. `artifacts/operations/CURRENT_TASK.md`
4. `guardrails/development/SHARED_CONTEXT_POLICY.md`
5. `development/[project-folder]/artifacts/shared/PROJECT_STATE.md`
6. `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`
7. latest relevant entries in `development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md`
8. relevant files under `development/[project-folder]/artifacts/shared/handoffs/`
9. related `development/[project-folder]/dev-doc/[feature-name]/` when the target repo keeps dev-doc inside itself
10. scaffold `artifacts/memory/` only after active operational and shared target context are read

If shared context files are missing during first target repo intake, create the baseline before handoff or implementation. Do not silently continue with only chat history.

## Mandatory Write After Meaningful Work

After any meaningful work, pause, handoff, QA closure, blocker discovery, implementation slice, or session close, the agent must update the target repository shared context:

- update `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`
- append to `development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md` only for contributor-session detail or handoff that needs information beyond the activity entry
- create or update the relevant handoff file under `development/[project-folder]/artifacts/shared/handoffs/`
- update `development/[project-folder]/artifacts/shared/PROJECT_STATE.md` when verified project facts, architecture, stack, routes/APIs, module boundaries, integrations, or environment requirements change

This write is mandatory for every developer because the next developer's agent may only receive the Git repository plus scaffold rules.

## Git-Safe Content Rules

Shared context must be safe to commit to the target repository.

Do not store:

- secrets, tokens, API keys, private keys, passwords, or production credentials
- `.env` values or private environment dumps
- personal credentials or private personal data
- raw chat transcripts
- large raw logs, traces, screenshots, videos, or generated reports
- absolute local machine paths unless necessary and explicitly marked as local-only
- model guesses that are not supported by repo evidence, artifacts, or founder instruction

Store concise verified summaries with source links instead.

`AI_ROUTING_LOG.md` may record only a task hash, routing class, model/profile, reasoning effort, relative token/cost band, status, and concise non-sensitive reasons. It must not store raw task text, prompts, secrets, escalation-evidence contents, or unverified actual token/cost data. A `legacy` profile entry means an explicit GPT-5.5 reproduction or benchmark request, never automatic fallback.

## Authority Order

When files conflict, use this order:

1. current target repository source and current evidence
2. target repo shared context under `development/[project-folder]/artifacts/shared/`
3. scaffold operational state under `artifacts/operations/`
4. target repo `dev-doc/`
5. scaffold memory under `artifacts/memory/`
6. older session logs or candidate memory

Shared context is stronger than chat history but cannot override current repo evidence or founder-locked decisions.

## Required Handoff Contents

Every shared handoff must include:

- feature and selected slice
- current status
- files changed
- decisions locked
- tests or QA performed
- tests or QA still pending
- blockers and risks
- allowed write paths for the next slice
- out-of-scope paths
- next exact step
- `Do Not Repeat` notes when relevant

## Stop Conditions

Stop before implementation or handoff if:

- target repo path is known but shared context files are missing and no baseline was created
- first intake lacks usable documentation and `PROJECT_STATE.md` does not record the required code-derived baseline or documented unknowns
- a meaningful session is closing without updating shared context
- required contributor-session or handoff detail was not appended to `CONTRIBUTOR_LOG.md`
- handoff file is missing for incomplete feature/slice work
- shared context contains secrets or raw transcripts
- shared context conflicts with current repo evidence and the conflict is not recorded

## Completion Rule

A target repo feature, QA, release, handoff, or meaningful implementation session is not `resume_safe`, `SUCCESS`, `ready to pr`, or complete until shared context is read before work and updated after work. The separate scaffold activity-log requirement is governed by `AGENT_ACTIVITY_LOG_POLICY.md`. During first intake, this includes `PROJECT_STATE.md` and the code-derived-baseline requirements when documentation is absent.
