# Framework Selector

Use this skill after architecture routing is approved and before any real app
bootstrap begins.

## Purpose

Skill ini membantu founder memilih dan mengunci:

- frontend framework
- frontend runtime
- backend framework
- backend runtime
- primary database
- database access layer
- cache layer
- package manager
- testing stack
- styling approach
- scaffold permission

Output dari skill ini harus cukup jelas sehingga builder dan QA bisa lanjut
tanpa menebak stack lagi.

## Read First

1. `artifacts/operations/CURRENT_PHASE.md`
2. `artifacts/operations/WORKFLOW_STATE.md`
3. `guardrails/architecture/FRAMEWORK_SELECTION_RULES.md`
4. `guardrails/architecture/FRAMEWORK_SCAFFOLD_REGISTRY.md`
5. `guardrails/database/DATABASE_SELECTION_RULES.md`
6. `guardrails/architecture/STACK_COMBINATION_GUIDE.md`
7. `templates/framework_decision_template.md`

## Required Output

Skill ini harus menghasilkan keputusan yang disetujui untuk:

- `frontend_framework`
- `frontend_runtime`
- `backend_framework`
- `backend_runtime`
- `primary_database`
- `database_access_layer`
- `cache_layer`
- `package_manager`
- `testing_stack`
- `styling_approach`
- `app_bootstrap_allowed`

## Activation Helpers

- `scripts/activate-framework-decision.ps1`
- `scripts/activate-framework-decision.sh`
- `scripts/prepare-framework-scaffold.ps1`
- `scripts/prepare-framework-scaffold.sh`
- `scripts/execute-framework-scaffold.ps1`
- `scripts/execute-framework-scaffold.sh`

Gunakan helper ini setelah founder sudah menyetujui stack final.

## Auto-Run Rule

Setelah framework decision di-approve:

1. aktifkan framework decision
2. jalankan `prepare-framework-scaffold`
3. jalankan `execute-framework-scaffold` dalam mode dry-run
4. tampilkan hasil scaffold plan ke founder

Jangan jalankan real execute di langkah ini kecuali founder memberi approval eksplisit.

## Guardrails

- Jangan asumsi React, Vue, Next.js, NestJS, FastAPI, atau Laravel tanpa persetujuan founder.
- Jangan jalankan bootstrap app jika `app_bootstrap_allowed` masih `no`.
- Jangan tulis scaffold ke route yang tidak aktif.

