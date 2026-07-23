# Agent Activity Log Policy

## Purpose

Provide one Git-carried, append-only activity record that tells the next developer or runtime which agent performed which meaningful task, under which task category, and what state the work reached.

The log is operational continuity, not a transcript, tool trace, or token telemetry store.

## Canonical Path And Boundaries

Use exactly one scaffold-level file:

`artifacts/operations/AGENT_ACTIVITY_LOG.md`

`AGENT_ACTIVITY_LOG.md` records concise agent activity across all target projects. Target-repository `CONTRIBUTOR_LOG.md` remains the richer contributor-session and handoff record. Target `AI_ROUTING_LOG.md` remains the model-routing record. Do not duplicate their complete contents across files; link to evidence paths instead.

## Required Events

Write one new entry only when one of these meaningful events occurs:

- a task slice or official step starts
- an agent begins a bounded delegated subtask
- task category, scope, risk, or active agent changes
- work becomes paused or blocked
- a model-routing escalation or `model_switch_unavailable` materially affects the task
- a meaningful implementation, QA, review, handoff, or session close completes

Do not write entries for individual file reads, searches, tool calls, command retries, or minor intermediate thoughts.

## Required Entry Fields

Every entry must include:

- `entry_id` and `created_at`
- `runtime` and `agent_role`
- `model_or_profile` when known, otherwise `not_recorded`
- `task_id`
- `target_project` (`[project-folder]|scaffold`)
- `task_size` (`small|medium|major`) and `task_category` (`intake|planning|coding|qa|review|handoff|release|scaffold_maintenance`)
- `feature` and `slice`
- `event` and `status` (`started|in_progress|paused|blocked|completed|handoff_ready`)
- concise `activity` summary
- up to three evidence or artifact paths
- one `next_step`

## Token-Efficient Read Rule

Before source scanning or continuing meaningful work, read only:

1. the metadata and `Current Activity Snapshot` in `AGENT_ACTIVITY_LOG.md`
2. the current task's entries and at most the three most recent relevant entries
3. linked target `ACTIVE_CONTEXT.md`, `CONTRIBUTOR_LOG.md`, handoff, routing, or QA evidence only when the snapshot or entry requires it

Do not read the entire activity log by default. Update `Current Activity Snapshot` only when active task, status, agent, blocker, or next step changes. Keep the snapshot to at most three bullets.

## Content And Storage Rules

- Keep each entry under 160 words and each activity summary under 400 characters.
- Never include raw prompts, chat transcripts, tool output, secrets, credentials, personal data, raw token counts, or unverified cost figures.
- Reference `AI_ROUTING_LOG.md` only when routing materially changed; do not copy routing reasons or cost bands into every activity entry.
- Preserve append-only entry history. Use Git history as the durable audit trail.
- When the file becomes difficult to search, add a concise dated index or use targeted search; do not force every agent to load all historical entries.

## Completion Rule

For scaffold or target-project meaningful work, `resume_safe`, `SUCCESS`, `ready to pr`, QA closure, handoff, or session close is invalid until the required activity event is logged. When a target project is active, its `ACTIVE_CONTEXT.md` must reference the current root activity-log entry.
