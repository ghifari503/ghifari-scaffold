# Agent Activity Log

## Metadata
- artifact_type: `scaffold_agent_activity_log`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`

## Current Activity Snapshot
- active_task_id: `[task-id-or-none]`
- active_target_project: `[project-folder|scaffold|none]`
- active_agent: `[runtime/agent-role-or-none]`
- current_status: `[started|in_progress|paused|blocked|completed|handoff_ready|none]`
- next_step: `[one exact action]`

## Entries

```markdown
### Entry: `ACT-YYYYMMDD-HHMM-[runtime]-[sequence]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[codex|claude|gemini|antigravity|manual]`
- agent_role: `[supervisor|builder|reviewer|qa|planner|other]`
- model_or_profile: `[gpt-5.6-terra / standard / supervisor|active_model_unavailable]`
- model_source: `[codex_router|runtime_status|agent_frontmatter|managed_configuration|unavailable]`
- model_availability_reason: `[router entry, runtime status source, or concise unavailable reason]`
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
- routing_log_reference: `[target AI_ROUTING_LOG.md entry or not_applicable]`
- next_step: `[one exact action]`
```
