# Agent Activity Log

## Metadata
- artifact_type: `scaffold_agent_activity_log`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`

## Current Activity Snapshot
- active_task_id: `[task-id-or-none]`
- active_target_project: `[project-folder|scaffold|none]`
- active_contributor_role: `[implementation|review|qa|planning|manual|other|none]`
- current_status: `[started|in_progress|paused|blocked|completed|handoff_ready|none]`
- next_step: `[one exact action]`

## Entries

```markdown
### Entry: `ACT-YYYYMMDD-HHMM-[sequence]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- contributor_role: `[implementation|review|qa|planning|manual|other]`
- task_id: `[task-id]`
- target_project: `[project-folder|scaffold]`
- task_size: `[small|medium|major]`
- task_category: `[intake|planning|coding|qa|review|handoff|release|scaffold_maintenance]`
- feature: `[feature-or-none]`
- slice: `[slice-or-none]`
- event: `[started|scope_changed|delegated|blocked|completed|handoff]`
- status: `[started|in_progress|paused|blocked|completed|handoff_ready]`
- activity: `[concise summary under 400 characters]`
- evidence:
  - `[path, max three]`
- next_step: `[one exact action]`
```
