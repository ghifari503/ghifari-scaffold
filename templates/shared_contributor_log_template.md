# Contributor Log

Append one entry for every meaningful work session.

Use scaffold `artifacts/operations/AGENT_ACTIVITY_LOG.md` for concise agent task events. Keep this log for contributor-session detail and handoff context; reference the relevant activity entry instead of duplicating it.

## Entry Template

```markdown
## Entry: `YYYYMMDD-HHMM-[developer-or-runtime]`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- contributor: `[developer/runtime]`
- feature: `[feature-or-none]`
- slice: `[slice-or-none]`
- status: `[in_progress|paused|blocked|completed|handoff_ready]`
- branch: `[branch-or-unknown]`
- commit: `[commit-or-unknown]`
- activity_log_entry: `[artifacts/operations/AGENT_ACTIVITY_LOG.md entry id]`

### Summary
- `[short summary]`

### Files Changed
- `[path]`

### Evidence
- `[test, artifact, decision, or source path]`

### QA
- unit: `[pass|fail|blocked|skipped + reason|unknown]`
- integration: `[pass|fail|blocked|skipped + reason|unknown]`
- e2e_browser: `[pass|fail|blocked|skipped + reason|unknown]`
- ui_visual: `[pass|fail|blocked|skipped + reason|unknown]`
- manual_visual_qa_required: `[yes|no]`
- manual_visual_qa_status: `[not_required|pending_founder_review|approved|rejected|blocked]`
- regression: `[pass|fail|blocked|skipped + reason|unknown]`

### Risks Or Blockers
- `[risk/blocker or none]`

### Next Exact Step
- `[one next action]`
```
