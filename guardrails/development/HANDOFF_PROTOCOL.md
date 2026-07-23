# HANDOFF_PROTOCOL

Use this protocol whenever work is handed from one model/runtime/session to another.

This repository assumes exactly one active task at a time.

## Objective
- Make task continuation deterministic across Claude, Codex, and Gemini CLI.
- Ensure the next runtime can continue without re-discovering the task state.
- Prevent hidden context from living only in chat history.

## When Handoff Is Mandatory
- End of session while task is still incomplete
- Switching from Claude to Codex
- Switching from Codex to Claude
- Switching to or from Gemini CLI for independent review, impact checking, or PR readiness
- Pausing a task because of blockers
- Asking another model to continue implementation or QA

## Required Read Order Before Continuing
1. `artifacts/operations/WORKFLOW_STATE.md`
2. `artifacts/operations/CURRENT_PHASE.md`
3. `artifacts/operations/CURRENT_TASK.md`
4. `artifacts/architecture/DECISION_LOG.md`
5. `artifacts/operations/SESSION_LOG.md`
6. `guardrails/development/PRE_CODING_POLICY.md`
7. `artifacts/operations/PRE_CODING_GATE.md`
8. `guardrails/development/SHARED_CONTEXT_POLICY.md`
9. Target repo `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md` when a target repo is attached
10. `artifacts/operations/AGENT_ACTIVITY_LOG.md` snapshot and relevant recent entries
11. Latest relevant target repo `development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md` entries when a target repo is attached
12. Relevant target repo `development/[project-folder]/artifacts/shared/handoffs/` files when a target repo is attached
13. `guardrails/memory/MEMORY_POLICY.md`
14. `artifacts/memory/MEMORY_INDEX.md`
15. `artifacts/memory/MEMORY_LEDGER.toml`
16. Every artifact listed under `Inputs / Source Docs` in `artifacts/operations/CURRENT_TASK.md`

No implementation should start until this read order is completed.
No implementation should start unless `guardrails/development/PRE_CODING_POLICY.md` allows the workflow shape and `artifacts/operations/PRE_CODING_GATE.md` allows the current mode and allowed write paths are documented.
Memory must be treated as advisory context and cannot override current operational artifacts or repository evidence.
Target repo shared context is the Git-carried developer-to-developer continuity layer and must be read before relying on scaffold-local memory for target repo work.
Use the `memory-curator` agent for memory recall or synchronization when memory affects the handoff.

## Resume-Safe Rule

The active task is `resume_safe = yes` only if all of the following are present in `artifacts/operations/CURRENT_TASK.md`:
- clear objective
- exact current status
- artifacts touched
- decisions locked
- remaining work
- exact next action
- pre-coding gate status when implementation may be requested

If any of these are missing, set `resume_safe = no`.

If `resume_safe = no`, the next model/runtime must first repair the task context before continuing implementation.

If the latest official step does not have a matching `SESSION_LOG.md` step entry, set `resume_safe = no` and repair the log before any handoff or implementation continues.

## Pre-Coding Handoff Rule

If the handoff asks the next runtime to implement, build, scaffold, install dependencies, migrate, generate code, or refactor, the handoff must include:
- `guardrails/development/PRE_CODING_POLICY.md` acknowledgement
- `artifacts/operations/PRE_CODING_GATE.md` status
- relevant memory entries from `artifacts/memory/`, if any
- target repo shared context status and relevant handoff path under `development/[project-folder]/artifacts/shared/`
- approved build mode
- allowed write paths
- out-of-scope paths when applicable
- founder approval reference
- `Do Not Repeat` notes for failed approaches, risky retries, or intentionally avoided paths

If any item is missing, the next runtime must treat the handoff as `planning_only` or `read_only_audit`, not implementation.

## Documentation Closure Rule

For any `medium` or `major` activity, handoff is not valid until documentation sync is complete.

Required before handoff or session close:
- `artifacts/operations/WORKFLOW_STATE.md` reflects the latest real state
- `artifacts/operations/CURRENT_TASK.md` reflects current status, touched artifacts, and exact next action
- `artifacts/operations/SESSION_LOG.md` contains the latest activity summary
- target repo shared context under `development/[project-folder]/artifacts/shared/` is updated when a target repo was involved
- `artifacts/operations/AGENT_ACTIVITY_LOG.md` contains the required meaningful-work event
- every relevant scope artifact changed by the work is updated or explicitly recorded as having no additional documentation delta

The handoff is invalid if the most recent official step is missing from `artifacts/operations/SESSION_LOG.md` or if the log entry was not written in the same documentation-sync batch.

If this sync is incomplete, set `resume_safe = no` and record the missing artifact updates as the blocker.

## Standard Handoff Format

Every substantial handoff must use this exact order:

1. Objective
2. Current State
3. Decisions Locked
4. Artifacts Updated
5. Remaining Work
6. Risks / Open Questions
7. Exact Next Step

When a failed approach, risky retry, or forbidden change path is known, include a `Do Not Repeat` subsection inside `Risks / Open Questions` or `Remaining Work` without changing the section order above.

This structure must stay consistent with `artifacts/operations/CURRENT_TASK.md` and `guardrails/system/RUNTIME_PARITY_CONTRACT.md`.

## Handoff Metadata

Whenever a handoff happens, record:
- `task_id`
- `handoff_at`
- `handoff_from`
- `handoff_to`
- `resume_safe`

Recommended values:
- `handoff_from`: `claude|codex|gemini|manual`
- `handoff_to`: `claude|codex|gemini|manual|unassigned`
- `resume_safe`: `yes|no`

## Session Log Requirement

Each session entry in `artifacts/operations/SESSION_LOG.md` must include:
- `active_task_id`
- `handoff_status`
- `resume_safe`
- `documentation_sync_status` for any `medium` or `major` activity

Each official step completion must have a matching step entry in `artifacts/operations/SESSION_LOG.md` before the next official step begins.

If a session ends with incomplete work, the handoff note must be written before closing the session.
If a target repo is involved, the shared handoff note must also be written under `development/[project-folder]/artifacts/shared/handoffs/` before closing the session.

## Consistency Rules

At any point in time, these values must agree:
- `artifacts/operations/CURRENT_TASK.md` -> `task_id`
- `artifacts/operations/CURRENT_PHASE.md` -> `active_task_id`
- latest session in `artifacts/operations/SESSION_LOG.md` -> `active_task_id`

If they do not agree, fix the documents before continuing work.

