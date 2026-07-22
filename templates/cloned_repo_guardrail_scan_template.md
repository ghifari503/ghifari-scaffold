# Cloned Repo Guardrail Scan Template

## Metadata
- project:
- repo_path_or_url:
- branch:
- commit:
- runtime: `[codex|claude|gemini|manual]`
- created_at:
- updated_at:
- status: `[draft|in_progress|blocked|done]`
- resume_safe: `[yes|no]`

## Scan Objective
- Why this guardrail scan is being created:
- What upcoming work depends on it:

## Local Guardrail Files Found
| File | Runtime Target | Type | Role | Material Impact |
|---|---|---|---|---|
| `AGENTS.md` |  | `explicit|pointer|inferred` |  | `yes|no` |
| `CLAUDE.md` |  | `explicit|pointer|inferred` |  | `yes|no` |
| `GEMINI.md` |  | `explicit|pointer|inferred` |  | `yes|no` |
| `.cursorrules` |  | `explicit|pointer|inferred` |  | `yes|no` |
| `CONTRIBUTING.md` |  | `explicit|pointer|inferred` |  | `yes|no` |

Add or remove rows as needed.

## Repository-Specific Rules That Affect Execution
### Commands
- install:
- dev/run:
- lint/typecheck:
- unit test:
- integration test:
- e2e/browser:
- build:

### Architecture And Codebase Rules
- rule 1:
- rule 2:
- rule 3:

### Contribution And Release Rules
- branch target:
- PR or review rule:
- CLA or signing rule:
- other:

## Explicit Vs Inferred Rules
- Explicit rules:
- Inferred rules:
- Areas still unclear:

## Conflict Scan
| Conflict ID | Files Involved | Conflict Type | Severity | Proposed Winner | Founder Confirmation Required |
|---|---|---|---|---|---|
| `GC-001` |  | `compatible|additive|ambiguous|hard` | `low|medium|high|critical` |  | `yes|no` |

## Resolution Notes
- Conflict:
- Decision:
- Reason:
- Recorded in:

## Stop Conditions
- unresolved_local_guardrail_files: `[yes|no]`
- unclear_command_inventory: `[yes|no]`
- write_path_mismatch: `[yes|no]`
- hard_conflict_present: `[yes|no]`
- unsafe_instruction_present: `[yes|no]`

## Final Intake Decision
- ready_for_readiness_baseline: `[yes|no|blocked]`
- reason:
- safest_next_step:
