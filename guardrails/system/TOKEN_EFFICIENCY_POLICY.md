# Token Efficiency And Progressive Context Policy

## Purpose

Enforce strict token efficiency across all AI runtimes (Antigravity, Codex, Claude, Gemini CLI) by preventing unsolicited heavy scans, prohibiting looping/duplicate updater executions, bounding progressive context loading, and optimizing ODN traceability queries.

## Core Rules

### 1. No Proactive Heavy Tooling Or Full-Scaffold Hashing
- Routine pre-task checks MUST use only the lightweight, no-network helper `scripts/check-scaffold-freshness.ps1` (or `.sh`).
- Agents are strictly prohibited from proactively executing `update-master-framework.ps1` (including dry-run), `reconcile-project-scaffold.ps1`, or full-scaffold manifest/hash generators without explicit founder authorization.
- When `check-scaffold-freshness.ps1` reports `update_available`, the agent must present a concise 1-2 sentence status summary to the founder and wait. Never run dry-run or calculate diff manifests automatically.

### 2. Single Execution Rule (No Looping Updates)
- Framework updates and target adoption checks run **exactly once** per new release or target switch.
- Once an update has been applied or when the updater HEAD matches the installed framework baseline (`STATE.json`), agents must never re-run dry-run or hash calculations in subsequent turns of the same session.
- Fast-path verification (comparing commit hashes or `STATE.json` version strings) must be used instead of full-file re-evaluations.

### 3. Limited Reconciliation Triggers
`scripts/reconcile-project-scaffold.ps1` is mandatory ONLY under two specific circumstances:
1. **Immediately after a Master Framework update** has been applied from `_framework-updater/`.
2. **Upon selecting, attaching, or resuming a Target Project** (`start`, `start dev`).

During normal implementation, refactoring, bug-fixing, or QA loops within the same active project, running reconciliation repeatedly across conversation turns is strictly prohibited.

### 4. ODN Progressive Context Boundaries
- **Never load all batch history:** Loading entire directories under `artifacts/traceability-local/[project]/` is prohibited.
- **Max 3 Batches Initially:** Identify `component` and `scope`, query lightweight code maps, and load at most three directly relevant ODN batches.
- **Expand Only on Explicit Missing Links:** Expand context only if a specific symbol, ADR, dependency, or related batch ID cannot be resolved from the initial 3 batches.
- **No Heavy Data Duplication:** ODN records must store only the rationale (*why*), acceptance criteria, architectural decisions, and Git trailers. Never duplicate ASTs, dependency graphs, full file dumps, or raw Graphify analysis in ODN batches.

### 5. Selective Skill Loading
- Do not dump or inspect all skill folders simultaneously.
- Look up only the specific skill relevant to the active gate or task type (e.g., `frontend-builder` for B2, `qa-runner` for R2).
- Read only `SKILL.md` when invoking a skill; auxiliary directories (`examples/`, `references/`) should only be read when explicitly required for execution.
