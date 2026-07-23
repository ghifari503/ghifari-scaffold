# Active Context

## Metadata
- target_project: `[project-folder]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_by: `[developer/runtime]`
- status: `[active|paused|blocked|handoff_ready]`
- git_branch: `[branch-or-unknown]`
- git_commit: `[commit-or-unknown]`

## Current Position
- active_feature: `[feature-or-none]`
- active_slice: `[slice-or-none]`
- current_status: `[short status]`
- current_gate: `[I1|I2|P1-P7|B1-B3|R1-R4|other]`
- resume_safe: `[yes|no]`
- activity_log_current_entry: `[artifacts/operations/AGENT_ACTIVITY_LOG.md entry id or none]`

## What Is Known
- `[verified project fact with source path]`
- project_state_baseline: `[artifacts/shared/PROJECT_STATE.md path and last verified date]`

## Decisions Locked
- `[decision with source path]`

## Current Scope
- allowed_write_paths:
  - `[path or glob]`
- blocked_paths:
  - `[path or glob]`
- out_of_scope:
  - `[item]`

## Latest Work Summary
- `[what changed or was learned]`

## QA Status
- unit: `[pass|fail|blocked|skipped + reason|unknown]`
- integration: `[pass|fail|blocked|skipped + reason|unknown]`
- e2e_browser: `[pass|fail|blocked|skipped + reason|unknown]`
- ui_visual: `[pass|fail|blocked|skipped + reason|unknown]`
- manual_visual_qa_required: `[yes|no]`
- manual_visual_qa_status: `[not_required|pending_founder_review|approved|rejected|blocked]`
- manual_visual_qa_reference: `[route/screenshot/approval reference]`
- security: `[pass|fail|blocked|skipped + reason|unknown]`
- performance: `[pass|fail|blocked|skipped + reason|unknown]`
- regression: `[pass|fail|blocked|skipped + reason|unknown]`

## Blockers
- `[blocker or none]`

## Next Exact Step
- `[one next action]`

## Do Not Repeat
- `[failed approach, risky retry, or forbidden path]`
