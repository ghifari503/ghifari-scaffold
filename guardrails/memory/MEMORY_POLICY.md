# MEMORY_POLICY

## Purpose
Provide persistent, auditable scaffold memory without letting stale notes override current project truth.

This policy governs how Codex, Claude, skills, and agents may read from or write to `artifacts/memory/`.

## Memory Curator Agent
Memory maintenance should be handled by the `memory-curator` agent whenever possible.

Agent definitions:
- Codex: `.codex/agents/memory-curator.md`
- Claude: `.claude/agents/memory-curator.md`

Use this agent after meaningful workflow events:
- existing-project intake
- impact scan
- approved founder decision
- architecture or framework decision
- QA failure or release incident
- command/workflow/process improvement
- handoff or resume preparation where memory affects the next step

The agent may update memory files, but it may not write product code or open workflow gates.

## Source Of Truth Order
When memory conflicts with other files, use this priority order:

1. Current repository files and current scan evidence.
2. Target repo shared context under `development/[project-folder]/artifacts/shared/` when a target repo is attached.
3. `artifacts/operations/CURRENT_TASK.md`
4. `artifacts/operations/WORKFLOW_STATE.md`
5. `artifacts/operations/CURRENT_PHASE.md`
6. `artifacts/architecture/DECISION_LOG.md`
7. Other current artifacts under `artifacts/`
8. Verified memory under `artifacts/memory/`
9. Candidate memory under `artifacts/memory/`

Memory is context, not authority.

## Memory Types
- `project_fact`: stable fact about the scaffold or target project.
- `workflow_pattern`: repeated operating pattern that should guide future work.
- `constraint`: limitation, blocker, rule of thumb, or inherited-system constraint.
- `decision_summary`: compact summary of an approved decision with a link to the decision source.
- `task_node`: task or dependency item used to resume future work.
- `feature_status`: current status, dependencies, impacted systems, gates, risks, and evidence for a known feature or module.
- `learning_summary`: reusable lesson extracted from `artifacts/improvement/LEARNINGS.md`.

## File Format Policy
- Use Markdown for rules, explanations, summaries, changelogs, and human review.
- Use `artifacts/memory/MEMORY_LEDGER.toml` as the machine-readable registry.
- Use `artifacts/memory/FEATURE_REGISTRY.toml` as the machine-readable feature/module status registry.
- Keep `artifacts/memory/MEMORY_INDEX.md` synchronized as the human-readable index.
- Keep category Markdown files synchronized for readable context.

TOML is used for the ledger because it is easier for agents and scripts to update safely than a Markdown table. Markdown remains the preferred format for founder review.

## Required Fields
Every memory entry must include:
- `id`
- `type`
- `status`
- `confidence`
- `created_at`
- `updated_at`
- `source`
- `summary`
- `review_after`

Allowed `status` values:
- `candidate`
- `verified`
- `superseded`
- `obsolete`

Allowed `confidence` values:
- `low`
- `medium`
- `high`

## Capture Rules
- Capture memory only from real artifacts, session logs, decision logs, intake outputs, impact scans, QA evidence, or explicit founder instruction.
- When documentation is absent, use `guardrails/development/CODE_DERIVED_BASELINE_POLICY.md`; capture only verified stable facts and targeted discovery paths from the completed source-linked `PROJECT_STATE.md` intake baseline.
- Do not create memory from model guesses.
- Do not store secrets, credentials, private keys, tokens, personal data, or environment-specific secrets.
- Do not store raw chat transcripts as memory.
- Prefer short, durable statements over long narrative summaries.
- Link each memory to a source path.

## Recall Rules
- Read memory after reading active operational state.
- Use memory only when it is relevant to the current task.
- Before feature or module source scanning, read relevant memory and feature registry entries to narrow the scan target.
- For target repo work, read `development/[project-folder]/artifacts/shared/PROJECT_STATE.md`, `ACTIVE_CONTEXT.md`, latest relevant `CONTRIBUTOR_LOG.md`, and relevant `handoffs/` before scaffold-local memory.
- Use `artifacts/memory/FEATURE_REGISTRY.toml` and `artifacts/memory/FEATURE_REGISTRY.md` to identify known modules, dependencies, impacted systems, evidence, and risks before reading source files.
- Do not repeat full repository understanding work when current operational state, memory, feature registry, dev-doc, intake, or impact evidence already identifies the relevant paths.
- If a full repo scan is still needed, record the reason in the active plan, current task, impact scan, or session log.
- If memory conflicts with current artifacts or repository evidence, mark it for review instead of following it.
- Do not use obsolete or superseded memory as an instruction.

## Maintenance Rules
- Review memory whenever project intake completes.
- Review memory after architecture decisions, framework decisions, major refactors, release incidents, or failed QA.
- Supersede old entries instead of editing away important history.
- Keep `artifacts/memory/MEMORY_LEDGER.toml` synchronized with memory category files.
- Keep `artifacts/memory/FEATURE_REGISTRY.toml` synchronized with `artifacts/memory/FEATURE_REGISTRY.md`.
- Keep `artifacts/memory/MEMORY_INDEX.md` synchronized with memory files.
