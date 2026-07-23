# LOGGING_STANDARD

Use this standard for all logging so records stay consistent, auditable, and easy to search.

## Goals
- Every record has a clear creation time.
- Every status change leaves a trace of who changed it and when.
- Cross-module logs use the same structure.

## Required Time Format

Use ISO 8601 timestamps with timezone offset.

Example:
- `2026-04-10T21:35:00+07:00`

Required time fields:
- `created_at`: first creation time, never changed
- `updated_at`: most recent update time
- `handoff_at`: handoff time when a task moves across runtime/session

## Required Metadata Header (for primary logs/artifacts)

Add this block near the top of the file:

```markdown
## Metadata
- module: `[feature-or-module]`
- artifact_type: `[brd|prd|flow|design|api|test|release|improvement|log]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[claude|codex|manual]`
- owner: `[name-or-role]`
- status: `[draft|in_progress|blocked|review|done]`
- task_id: `[single active task id when relevant]`
- resume_safe: `[yes|no]`
```

## Entry-Level Log Format (for SESSION_LOG, LEARNINGS, BUG)

Every entry must include:
- `entry_id`
- `created_at`
- `updated_at`
- `task_id`
- `module`
- `status`

Example:

```markdown
### Entry: `BUG-auth-login-001`
- created_at: `2026-04-10T21:35:00+07:00`
- updated_at: `2026-04-10T22:10:00+07:00`
- task_id: `TASK-20260410-001`
- module: `auth-login`
- status: `open`
- summary: `Login fails even when the password is valid`
- detail: `...`
- next_action: `Investigate auth handler`
```

## Standard Status Enums

### Workflow/Step
- `PENDING`
- `BLOCKED`
- `IN PROGRESS`
- `SUCCESS`
- `FAILED`
- `PAUSED`

### Bug
- `open`
- `triaged`
- `in_progress`
- `fixed`
- `verified`
- `closed`
- `reopened`

### Artifact Maturity
- `draft`
- `in_review`
- `approved`
- `obsolete`

### Resume Safety
- `yes`
- `no`

## Recommended File Naming

Use:
- `YYYYMMDD_HHMM_<artifact>_<module>.md`

Examples:
- `20260410_2135_bug-log_auth-login.md`
- `20260410_2200_frontend-qa_auth-login.md`

## Change Size Classification

Use this lightweight classification when deciding whether end-of-activity documentation sync is mandatory.

- `small`: one narrow file or one tightly scoped fix with no meaningful workflow, QA, release, or cross-artifact impact
- `medium`: multiple related files, shared UI/component/query behavior, QA evidence changes, bug lifecycle movement, or any scoped work that changes more than one source-of-truth artifact
- `major`: cross-module or cross-repo work, architecture/flow/design changes, release-affecting work, broad bug batches, PR-preparation branches, or anything that materially changes operational history

## Medium/Major Plan-First Logging

- Every `medium` or `major` activity must record that a compact plan was presented and explicitly approved before execution.
- The approval may be recorded in `artifacts/operations/SESSION_LOG.md`, `artifacts/operations/CURRENT_TASK.md`, or the relevant plan/checklist artifact.
- If execution starts before approval, mark the step `PAUSED`, record the missing approval as the blocker, and do not mark the activity `SUCCESS`, `resume_safe`, `fixed`, `verified`, `closed`, or `ready to pr`.

## Logging Locations

- Session log: `artifacts/operations/SESSION_LOG.md`
- Scaffold agent activity log: `artifacts/operations/AGENT_ACTIVITY_LOG.md`
- Learnings: `artifacts/improvement/LEARNINGS.md`
- Workflow state: `artifacts/operations/WORKFLOW_STATE.md`
- Current phase: `artifacts/operations/CURRENT_PHASE.md`
- Current task: `artifacts/operations/CURRENT_TASK.md`
- Handoff rules: `guardrails/development/HANDOFF_PROTOCOL.md`
- Per-module bug log: `artifacts/test/[module]-bug-log.md`
- Per-module bug status: `artifacts/test/[module]-bug-status.md`

## Operating Rules

- Never change `created_at` after an entry is created.
- Every status change must update `updated_at`.
- For scaffold or target-project meaningful work, append one event-based entry to `artifacts/operations/AGENT_ACTIVITY_LOG.md` using `guardrails/development/AGENT_ACTIVITY_LOG_POLICY.md`. Never log per tool call; agents read only its snapshot and relevant recent entries.
- When a task moves across model/session, fill `handoff_at`, `handoff_from`, `handoff_to`, and `resume_safe`.
- Every official workflow step must create or update a matching `artifacts/operations/SESSION_LOG.md` step entry before the next official step or handoff.
- If a step finishes without a session log entry, treat the activity as incomplete and do not mark it `SUCCESS`, `fixed`, `verified`, `closed`, `resume_safe`, or `ready for the next task`.
- Every `medium` or `major` activity must end with documentation sync before it may be reported as complete, paused, handed off, or ready for the next task.
- Minimum required operational sync for `medium` or `major` activity:
  - `artifacts/operations/WORKFLOW_STATE.md`
  - `artifacts/operations/CURRENT_TASK.md`
  - `artifacts/operations/SESSION_LOG.md`
- Also update every relevant scope artifact touched by the work, such as root `bug-listing/`, bug log/status, design docs, API specs, release notes, decision log, learnings, memory, or feature registry.

## Bug Listing Sync

- Founder-editable bug-fix input belongs in root `bug-listing/`.
- Default bug queue/index: `bug-listing/list-bug.md`.
- Dynamic bug queue files: `bug-listing/[bug-list-name].md`.
- Runtime-maintained bug evidence belongs in `artifacts/test/[module]-bug-log.md` and `artifacts/test/[module]-bug-status.md`.
- Do not create new founder-facing bug lists under `artifacts/test/bug-list/`.
- Every bug in `bug-listing/` must use a stable `bug_id`.
- The bug listing entry must contain at least: `bug_id`, `module`, `page_issue`, `as_is`, `expected_result`, `status`, and `updated_at`.
- If a bug status becomes `fixed`, `verified`, or `closed`, the root bug listing entry must include evidence references.
- Do not store passwords, API keys, tokens, or private credentials in bug listing files.
- If no scope-specific artifact changed beyond the operational trio, record `documentation_sync_status: no additional documentation delta required` in `artifacts/operations/SESSION_LOG.md`.
- `resume_safe`, `SUCCESS`, `fixed`, `verified`, `closed`, and PR-readiness claims are invalid for `medium` or `major` work while documentation sync is pending.
- For `medium` or `major` work, `artifacts/operations/SESSION_LOG.md` must record `documentation_sync_status` in the session entry for the latest step.
- If a bug status becomes `fixed`, add test/verification evidence.
- If a bug status becomes `closed`, reference the `verified` evidence.

## Handoff Fields

Use these fields for cross-model continuity:
- `task_id`
- `started_by_runtime`
- `last_updated_by_runtime`
- `handoff_at`
- `handoff_from`
- `handoff_to`
- `resume_safe`

