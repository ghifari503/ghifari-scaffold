# Granular QA Evidence Template

Use this template for final QA evidence before final impact check and PR readiness.

## Metadata
- module: `[feature-or-module]`
- artifact_type: `test`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[codex|claude|gemini|manual]`
- owner: `founder`
- status: `[draft|in_progress|blocked|done]`
- task_id: `[task-id]`
- resume_safe: `[yes|no]`

## QA Scope
- requirement_source:
- qa_scope_source: `[impact_scan|approved_task_slice|implementation_plan|existing_project_requirement]`
- implementation_scope:
- non_scope:
- target_repo:
- tested_paths:
- skipped_paths_with_reason:
- delta_since_last_passing_point:
- last_passing_point:
- broad_or_full_suite_run: `[yes|no]`
- broad_or_full_suite_reason: `[not_applicable|allowed_reason]`
- command_output_summary_policy: `concise_summary_with_durable_evidence_path_for_large_output`
- durable_evidence_paths:

## Unit QA
- required: `[yes|no]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## Integration QA
- required: `[yes|no]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## E2E / Browser QA
- required: `[yes|no]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## UI / Visual QA
- required: `[yes|no]`
- manual_visual_qa_required: `[yes|no]`
- manual_visual_qa_reason:
- impacted_pages_routes_states:
- local_url_or_preview:
- screenshot_or_recording_evidence:
- founder_visual_approval_status: `[not_required|pending|approved|rejected|blocked]`
- founder_visual_approval_reference:
- manual_visual_qa_checklist:
  - `[item]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## Security QA
- required: `[yes|no]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## Performance QA
- required: `[yes|no]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## Regression QA
- required: `[yes|no]`
- command_or_method:
- result: `[pass|fail|blocked|skipped]`
- evidence:
- notes:

## Existing Failures / Known Issues
- baseline_failures:
- new_failures:
- known_issues:
- deferred_with_approval:

## Decision
- final_qa_status: `[passed|failed|blocked|needs_review]`
- reason:
- required_before_final_impact_check:
- next_step:
