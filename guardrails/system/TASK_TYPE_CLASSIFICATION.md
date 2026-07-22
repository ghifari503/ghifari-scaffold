# Task Type Classification Policy

## Purpose

Every runtime must classify the requested work before significant scaffold work, planning, coding, QA, handoff, or review.

This policy applies to Codex/GPT, Claude, and Gemini.

## Source Files

- Registry: `guardrails/system/TASK_TYPE_REGISTRY.md`
- Template: `templates/task_classification_template.md`
- Runtime parity: `guardrails/system/RUNTIME_PARITY_CONTRACT.md`

## Required Behavior

Before significant work, the runtime must produce or internally record a task classification with:

- user intent
- primary task type
- secondary task types, if any
- confidence
- risk level
- required gates
- required artifacts
- required tests
- stop conditions

For `medium`, `major`, ambiguous, or high-risk work, the classification must be written or summarized in `artifacts/operations/SESSION_LOG.md`.

## User Does Not Need To Know The Task Type

The founder may describe work in natural language.

The runtime should infer the likely task type using `TASK_TYPE_REGISTRY.md`.

The runtime may proceed without asking only when all are true:

- classification confidence is `high`
- risk level is `low`
- the work is read-only or documentation-only, or all required gates are already satisfied
- no architecture, database, dependency, security, production, or broad refactor risk is detected

## Confirmation Required

Ask for founder confirmation before continuing when any of these are true:

- confidence is `low` or `medium`
- risk level is `medium`, `high`, or `critical`
- task type is ambiguous
- scope is broad or crosses modules
- behavior change is unclear
- database/schema/data migration may be involved
- dependency or framework changes may be involved
- security, auth, permission, payment, or production behavior may be involved
- architecture boundary may change
- allowed write paths are missing
- pre-coding gate is blocked

## Auto-Mapping Rules

The runtime should map common intent phrases:

- "tambah", "buat fitur", "lanjutkan fitur" -> `feature-development`
- "bug", "error", "tidak tampil", "salah", "fix" -> `bug-fix`
- "buat HTML", "mockup", "cangkang UI", "prototype" -> `ui-prototype`
- "ubah tampilan", "samakan desain", "revamp" -> `ui-revamp`
- "rapikan code", "pecah service", "refactor" -> `refactor`
- "integrasikan", "hubungkan API", "connect" -> `integration`
- "migration", "schema", "tambah kolom" -> `database-change`
- "migrasi data", "import data", "cleanup data" -> `data-migration`
- "buat test", "unit test", "Playwright", "E2E" -> `test-automation`
- "lambat", "optimize", "query berat" -> `performance-optimization`
- "security", "permission", "token", "XSS", "auth leak" -> `security-fix`
- "upgrade package", "update dependency" -> `dependency-upgrade`
- "deploy", "CI/CD", "release", "rollback" -> `devops-deployment`
- "urgent", "production error", "hotfix" -> `incident-hotfix`
- "update docs", "sync docs", "handoff" -> `documentation-sync`
- "review", "audit", "cek saja" -> `review-only`
- "migrasi artifact lama" -> `legacy-artifact-migration`
- "start dev", "jalankan lokal", "cek env" -> `local-dev-readiness`

## Multi-Type Rule

Some requests have more than one type. Choose:

- `primary_task_type`: the thing that determines gates and risk
- `secondary_task_types`: related work that affects artifacts or tests

Example:

```text
primary_task_type: bug-fix
secondary_task_types: ui-revamp, test-automation
```

## Risk Defaults

Use the registry default risk unless the specific request is clearly safer or riskier.

When uncertain, increase risk rather than lowering it.

## Stop Conditions

Stop before implementation when:

- task type cannot be classified
- founder intent conflicts with current artifacts
- required input is missing
- required gate is blocked
- allowed write paths are missing
- requested action would write outside approved paths
- verification path is unknown for risky work

## Output Shape

Use the template in `templates/task_classification_template.md`.

For short clarification-only responses, a compact summary is allowed, but the same fields must be considered.

