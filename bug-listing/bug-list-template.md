# [bug-list-name] Bug Listing

## Metadata
- bug_list_name: `[bug-list-name]`
- scope_type: `[module|page|role|flow|sprint|release|regression|mixed]`
- scope_name: `[scope-name]`
- module: `[module-name-or-multiple]`
- artifact_type: `bug_listing`
- created_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- runtime: `[manual|codex|claude|gemini]`
- owner: `[founder|runtime]`
- status: `draft`
- task_id: `TASK-YYYYMMDD-001`
- resume_safe: `yes`
- index_reference: `bug-listing/list-bug.md`

## Usage

- Keep one section per bug.
- Keep `bug_id` stable after creation.
- Update `status` and `updated_at` on every meaningful change.
- If `status` becomes `fixed`, add `fix_reference`.
- If `status` becomes `verified`, add `verification_reference`.
- If `status` becomes `closed`, keep verification evidence and set `closed_at`.
- Do not put credentials, tokens, API keys, or private secrets in this file.

### BUG-[module]-[001]
- bug_id: `BUG-[module]-[001]`
- module: `[module-name]`
- severity: `[critical|high|medium|low]`
- status: `open`
- page_issue: `Page or UI area where the issue appears`
- as_is: `Describe the current bug`
- how_to_reproduce: `Describe the reproduction steps without exposing secrets`
- expected_result: `Describe the expected behavior`
- evidence_link: `pending`
- fix_reference: `pending`
- verification_reference: `pending`
- updated_at: `YYYY-MM-DDTHH:mm:ss+07:00`
- closed_at: `not_closed`
