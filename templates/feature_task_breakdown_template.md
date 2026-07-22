# Feature Task Breakdown

## Metadata
- feature: `[feature-name]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[codex|claude|gemini]`
- owner: `founder`
- status: `[draft|approved|blocked|completed]`

## Requested Outcome
- request_summary: `[what the founder asked for]`
- business_goal: `[why this matters]`
- user_or_actor: `[primary actor]`

## Context First
- workflow_state_read: `[yes|no]`
- current_task_read: `[yes|no]`
- project_context_read: `[yes|no]`
- memory_index_read: `[yes|no]`
- memory_ledger_read: `[yes|no]`
- feature_registry_read: `[yes|no]`
- related_dev_doc_read: `[yes|no|missing]`
- latest_session_log_read: `[yes|no]`

## Relevant Context And Memory
- verified_context:
  - `[source path]: [short fact]`
- relevant_memory:
  - `[memory id or source path]: [short fact]`
- conflicts_or_stale_memory:
  - `[none|details]`

## Feature Slices

| Slice ID | Slice Name | Outcome | Risk | Status |
|---|---|---|---|---|
| `S1` | `[slice name]` | `[small result]` | `[low|medium|high]` | `[selected|deferred|blocked|done]` |

## Selected Slice For This Session
- slice_id: `[S1]`
- objective: `[single-session objective]`
- acceptance_criteria:
  - `[criterion]`
- impacted_actor_or_flow:
  - `[actor/flow]`
- dependencies:
  - `[dependency or none]`
- blockers:
  - `[blocker or none]`

## Targeted Scan Plan
- full_repo_scan_allowed: `[no|yes]`
- full_repo_scan_reason: `[required if yes]`
- search_terms:
  - `[feature slug, route, symbol, endpoint, table, label]`
- targeted_paths:
  - `[path or glob]`
- adjacent_pattern_paths:
  - `[path or glob]`

## Build Scope
- allowed_write_paths:
  - `[path or glob]`
- blocked_paths:
  - `[path or glob]`
- out_of_scope:
  - `[deferred item]`

## QA Scope
- unit: `[required|skipped + reason]`
- integration: `[required|skipped + reason]`
- e2e_browser: `[required|skipped + reason]`
- ui_visual: `[required|skipped + reason]`
- security: `[required|skipped + reason]`
- performance: `[required|skipped + reason]`
- regression: `[required|skipped + reason]`

## Founder Approval
- approval_status: `[pending|approved|rejected]`
- approval_reference: `[chat/date/artifact]`

## Deferred Slices
- `[slice id]: [why deferred]`

## Next Exact Step
- `[next step]`
