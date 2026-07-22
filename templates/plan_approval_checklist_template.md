# Plan Approval Checklist Template

## Metadata
- task_id: `[task-id]`
- context_name: `[feature-or-module-name]`
- artifact_type: `plan_approval_checklist`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[codex|claude|gemini|manual]`
- owner: `founder`
- status: `[pending_review|changes_requested|approved|blocked]`
- build_coding_status: `[blocked|allowed]`

## Request Summary
- request_source:
- scoped_change_summary:
- related_plan_artifact: `plan/[context-name]-[YYYY-MM-DD].md`
- related_task_artifact: `artifacts/operations/CURRENT_TASK.md`

## Review Status
- founder_review_status: `[pending_review|changes_requested|approved]`
- founder_review_notes:
- founder_approval_reference:
- allowed_write_paths_reference:
- blocked_paths_reference:

## Checklist
- [ ] Scope is clear and limited to one approved feature/module/change request.
- [ ] Matching plan file exists in the root `plan/` folder.
- [ ] The plan includes objective, scope, impacted modules/files, execution steps, QA plan, and rollback notes.
- [ ] Founder has reviewed the drafted plan.
- [ ] Explicit founder approval reference is recorded.
- [ ] Allowed write paths are defined, or the reason they are still deferred is documented.
- [ ] Out-of-scope or blocked paths are documented when relevant.
- [ ] `artifacts/operations/CURRENT_TASK.md` is aligned with the same scoped work.
- [ ] Build/coding remains blocked until this checklist is fully approved.

## Notes
- implementation_blocker_notes:
- follow_up_actions:
