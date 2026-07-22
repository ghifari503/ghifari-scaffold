# Conflict Resolution Rule

## Purpose
This rule defines how Codex, Claude, Gemini, and compatible AI contributors must detect, classify, resolve, and document conflicts between scaffold guardrails and cloned-repository rules.

Use this rule together with:
- `guardrails/system/GUARDRAIL_PRECEDENCE_POLICY.md`
- `guardrails/system/CLONED_REPO_INTAKE_CHECKLIST.md`

## Conflict Types

### 1. Compatible
Both rules can be applied without tension.

Example:
- Scaffold requires final QA evidence.
- Repository defines the exact test command to produce that evidence.

Action:
- apply both
- no escalation needed

### 2. Additive
One rule is more specific but does not invalidate the other.

Example:
- Scaffold requires documentation sync.
- Repository adds a specific changelog or PR template expectation.

Action:
- apply both
- record the repository-specific addition in intake or handoff notes when relevant

### 3. Ambiguous
The rules appear to overlap, but the winning interpretation is not obvious.

Example:
- Scaffold expects one workflow artifact path.
- Repository has its own historical docs path and it is unclear whether both must be updated.

Action:
- pause before coding if the ambiguity affects execution, logging, QA, release, or write paths
- ask the founder when the safest interpretation is not clear
- document the chosen rule

### 4. Hard Conflict
Following one rule would violate another rule.

Example:
- Repository suggests direct production-impacting commands without scaffold approval.
- Repository contribution guidance conflicts with scaffold safety or write-path boundaries.

Action:
- stop
- escalate to founder
- do not proceed until the conflict is explicitly resolved

## Resolution Order
When a true conflict exists, resolve in this order:

1. Platform and safety rules win
2. Scaffold process and evidence rules win
3. Founder-approved task scope and active operational state win over default assumptions
4. Repository-local technical execution rules win for codebase-specific behavior
5. Inferred conventions lose to explicit written rules

## Practical Resolution Matrix

### Process Conflict
Topics:
- gate order
- approvals
- logging
- handoff
- artifact paths
- QA evidence status labels

Default winner:
- scaffold

### Technical Execution Conflict
Topics:
- test command
- package manager
- Docker usage
- folder layout
- framework convention
- repository pattern

Default winner:
- cloned repository

### Risk Or Safety Conflict
Topics:
- destructive commands
- migrations without rollback
- secrets exposure
- production data access
- unsafe environment changes

Default winner:
- safety boundary, then founder escalation if needed

### Business Or Scope Conflict
Topics:
- what feature is in scope
- whether a refactor is allowed
- whether a repo convention may be intentionally broken

Default winner:
- explicit founder decision, documented in active task artifacts

## Mandatory Escalation Triggers
Escalate before proceeding if any of these occurs:
- repository instructions conflict with pre-coding gate requirements
- repository instructions require commands with unclear blast radius
- repository docs contradict each other
- local rules appear outdated and the safe interpretation is not obvious
- test or migration rules may damage data or invalidate baseline evidence
- repository asks for branch, PR, or release behavior that changes delivery risk materially

## Documentation Requirement
Every ambiguous or hard conflict must be recorded in at least one active artifact:
- intake note
- readiness baseline
- `artifacts/operations/SESSION_LOG.md`

If the decision creates a lasting repository rule or exception, also record it in:
- `artifacts/architecture/DECISION_LOG.md`

## Handoff Requirement
Handoff notes must include unresolved or recently resolved guardrail conflicts with:
- the conflicting files
- the chosen winner
- the reason
- any founder approval that was required

## Examples

### Example A
- Scaffold says local readiness is not implementation.
- Repository says run backend tests inside Docker.

Resolution:
- compatible
- keep scaffold gate meaning
- use the repository Docker command when testing is actually approved

### Example B
- Scaffold requires granular QA evidence.
- Repository has only unit tests and no browser tests.

Resolution:
- additive
- use repository unit stack
- mark missing layers as `blocked` or `skipped` with reason instead of pretending they passed

### Example C
- Repository says edit generated files directly.
- Scaffold and codebase indicate those files are generated artifacts.

Resolution:
- hard conflict
- stop and verify the real generator path or founder-approved exception before editing
