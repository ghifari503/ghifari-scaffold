# Runtime Parity Contract (Codex/GPT + Claude + Gemini)

Use this contract when the founder requires the same process and output shape
across Codex/GPT, Claude, and Gemini runs.

## Objective
- Keep workflow gates identical across runtimes.
- Keep artifact paths and naming identical across runtimes.
- Keep response structure identical for substantial outputs.
- Prevent runtime-specific drift except for truly unavoidable tool differences.

## Mandatory Process Parity

All supported runtimes MUST execute the same phase/gate sequence:

0. Task type classification
1. Interview and clarify
2. Requirement synthesis
3. User/system flow
4. Design mapping/completion
5. Frontend build
6. Frontend QA
7. API spec finalization
8. API QA
9. Backend build
10. Backend QA
11. DB changes and DB QA
12. Integration QA
13. E2E QA
14. Security QA signoff
15. Release prep
16. Release check
17. Improvement capture

Gate rule: if evidence for a gate is missing, next gate remains blocked.

Task classification rule: before significant work, all runtimes must use `guardrails/system/TASK_TYPE_CLASSIFICATION.md`, `guardrails/system/TASK_TYPE_REGISTRY.md`, and `templates/task_classification_template.md` for the same task type names, risk labels, gate mapping, and stop conditions.

AI contributor lifecycle rule: when working on a cloned, attached, inherited, or scaffold-managed project, all runtimes must preserve the lifecycle overlay in `workflows/ai_contributor_lifecycle.md`, including readiness baseline, implementation planning, during-development QA, self review, granular final QA evidence, final impact checking, handoff, and PR readiness.

## Mandatory Artifact Parity

All supported runtimes MUST write evidence to the same locations:

- BRD: `dev-doc/[feature-name]/brd.md`
- PRD: `dev-doc/[feature-name]/prd.md`
- Flows: `artifacts/flows/[feature]-*.md`
- Design: `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/`
- API: `artifacts/architecture/api-specs/[feature]-openapi.yaml`
- API notes: `artifacts/architecture/api-specs/[feature]-api-spec.md`
- Test evidence: `artifacts/test/[feature]-*.md`
- Granular QA evidence: `artifacts/test/[feature]-qa-evidence.md`
- Release evidence: `artifacts/release/[feature]-*.md`
- Improvement: `artifacts/improvement/[feature]-*.md`
- Task classification template: `templates/task_classification_template.md`
- Granular QA template: `templates/granular_qa_evidence_template.md`

## Mandatory Output Format Parity

For substantial task outputs, all supported runtimes MUST use this section order:

1. Objective
2. Assumptions
3. Artifacts Updated
4. Result Summary
5. Risks / Open Questions
6. Next Step

Do not reorder these headings unless user explicitly requests a different format.

## Mandatory Handoff Format Parity

For substantial handoff and resume notes, all supported runtimes MUST use this exact order:

1. Objective
2. Current State
3. Decisions Locked
4. Artifacts Updated
5. Remaining Work
6. Risks / Open Questions
7. Exact Next Step

This handoff structure must match `artifacts/operations/CURRENT_TASK.md` and `guardrails/development/HANDOFF_PROTOCOL.md`.

## Status Label Parity

Use only these values in workflow state and session reporting:

- `PENDING`
- `BLOCKED`
- `IN PROGRESS`
- `SUCCESS`
- `FAILED`
- `PAUSED`

Traffic-light status for dashboards MUST use:
- `GREEN`
- `YELLOW`
- `RED`

## Runtime-Specific Exceptions (Allowed)

These differences are allowed and do not count as parity violation:

- Runtime-specific command syntax (`claude`, `codex`, or Gemini CLI)
- Runtime-specific connector configuration paths (`.claude/`, `.codex/`, and Gemini CLI local configuration)
- Runtime-specific guard environment variables needed for tool execution

All other differences (process order, evidence paths, output structure) are not allowed.

## Parity Verification Checklist

Before ending a session, verify:

- Same gate sequence used
- Same artifact path conventions used
- Same output section ordering used
- Same status labels used
- Runtime-specific differences limited to allowed exceptions
