# DOCUMENT_STANDARDS

## Style
- concise
- structured
- implementation-ready
- avoid fluff
- list assumptions explicitly

## Every formal artifact should include
- objective
- context
- scope
- actors
- assumptions
- success criteria
- risks
- open questions
- next recommended step

## Storage Location

Before creating or updating any formal artifact, follow `guardrails/development/ARTIFACT_STORAGE_POLICY.md`.

Do not create these removed legacy roots:
- `artifacts/brd/`
- `artifacts/prd/`
- `artifacts/design/`

Active feature BRD, PRD, and design belong under:

```text
dev-doc/[feature-name]/
```

## File Naming
- **Strict Character Set:** Use only ASCII characters: lowercase letters (`a-z`), numbers (`0-9`), underscores (`_`), and hyphens (`-`).
- **Prohibition:** Do NOT use spaces, Unicode characters (including Chinese, Arabic, etc.), or special symbols that require encoding escapes.
- **Artifact Format:** Use `YYYYMMDD_<artifact>_<feature>.md` for formal artifacts.
Example:
- `20260407_prd_activation_flow.md`

## Logging and Timestamps
- Every log and formal artifact should include `created_at` and `updated_at`.
- Use ISO 8601 format with timezone offset, example: `2026-04-10T21:35:00+07:00`.
- Do not modify `created_at` after first creation.
- Update `updated_at` on every meaningful change.
- Follow `guardrails/development/LOGGING_STANDARD.md` for log entry structure and status enums.

