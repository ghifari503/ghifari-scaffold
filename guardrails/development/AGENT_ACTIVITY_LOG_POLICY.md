# Agent Activity Log Policy

## Purpose

Provide one Git-carried, append-only activity record that tells the next contributor which meaningful task occurred, under which task category, and what state the work reached.

The log is operational continuity, not a transcript, tool trace, or token telemetry store.

## Canonical Path And Boundaries

Use exactly one scaffold-level file:

`artifacts/operations/AGENT_ACTIVITY_LOG.md`

`AGENT_ACTIVITY_LOG.md` records concise activity across all target projects. Rich identity-free lifecycle, handoff, contributor/process, and development state resolves from Master Scaffold `artifacts/traceability-local/[project]/`; routing is ephemeral and target shared facts remain client-safe. Do not duplicate complete contents across files.

## Required Events

Write one new entry only when one of these meaningful events occurs:

- a task slice or official step starts
- a bounded work unit begins
- task category, scope, or risk changes
- work becomes paused or blocked
- an execution-capability blocker materially affects the task
- a meaningful implementation, QA, review, handoff, or session close completes

Do not write entries for individual file reads, searches, tool calls, command retries, or minor intermediate thoughts.

## Required Entry Fields

Every entry must include:

- `entry_id` and `created_at`
- `contributor_role` (`implementation|review|qa|planning|manual|other`)
- `task_id`
- `target_project` (`[project-folder]|scaffold`)
- `task_size` (`small|medium|major`) and `task_category` (`intake|planning|coding|qa|review|handoff|release|scaffold_maintenance`)
- `feature` and `slice`
- `event` and `status` (`started|in_progress|paused|blocked|completed|handoff_ready`)
- concise `activity` summary
- up to three evidence or artifact paths
- one `next_step`

### Identity-Prohibition Rule

Do not record a runtime, provider, model, profile, agent name, engineer identity, routing source, token band, or cost band. Use only the neutral `contributor_role` and work evidence defined in `INTERNAL_CONTINUITY_IDENTITY_POLICY.md`.

## Token-Efficient Read Rule

Before source scanning or continuing meaningful work, read only:

1. the metadata and `Current Activity Snapshot` in `AGENT_ACTIVITY_LOG.md`
2. the current task's entries and at most the three most recent relevant entries
3. linked Master Scaffold ODN batch, internal handoff, or QA evidence only when the snapshot or entry requires it

Do not read the entire activity log by default. Update `Current Activity Snapshot` only when active task, status, agent, blocker, or next step changes. Keep the snapshot to at most three bullets.

## Content And Storage Rules

- Keep each entry under 160 words and each activity summary under 400 characters.
- Never include raw prompts, chat transcripts, tool output, secrets, credentials, personal data, raw token counts, or unverified cost figures.
- Do not reference routing identity evidence. Record a neutral blocker only when the work cannot continue safely.
- Preserve append-only entry history. Use Git history as the durable audit trail.
- When the file becomes difficult to search, add a concise dated index or use targeted search; do not force every agent to load all historical entries.

## Completion Rule

For scaffold or target-project meaningful work, `resume_safe`, `SUCCESS`, `ready to pr`, QA closure, handoff, or session close is invalid until the required identity-free activity event is logged. When a target is active, Master Scaffold internal traceability links the current root activity-log entry; the target must not receive it.
