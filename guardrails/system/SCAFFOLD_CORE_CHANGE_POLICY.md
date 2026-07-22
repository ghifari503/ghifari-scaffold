# Scaffold Core Change Policy

## Purpose

Allow Odonplay teams to extend the scaffold without weakening or silently changing the shared workflow baseline.

## Protected Core

The following paths define protected scaffold behavior:

- `AGENTS.md`
- `COMMANDS.md`
- `SCAFFOLD_WORKFLOW.md`
- `guardrails/`
- `workflows/`
- `templates/`
- `.codex/`
- `.claude/`
- `scripts/`
- `.github/`
- `.githooks/`
- `.codex/model-routing.json`
- `guardrails/system/MODEL_ROUTING_POLICY.md`

## Allowed Team Extensions

Teams may add project-specific material under a target repository, including `dev-doc/`, project source, project tests, project automation, and `development/[project-folder]/artifacts/shared/`.

Teams may add scaffold skills, agents, templates, and documentation when the change does not bypass required gates or contradict protected policies.

## Core Change Requirements

Before changing protected core paths:

1. Classify the request and present a compact plan when medium or major.
2. Explain why a project-specific extension is insufficient.
3. Identify affected gates, runtime behavior, templates, documentation, and CI checks.
4. Obtain founder or CODEOWNERS approval before merge.
5. Update related policies, command guidance, workflow documentation, and operational artifacts.
6. Run relevant validation, including skill synchronization when skills change.

## Prohibited Changes

Do not remove or weaken plan approval, skill lookup, dev-doc discovery, requirement precedence, readiness baseline, pre-coding controls, shared context, QA evidence, documentation sync, handoff, or founder-only decision boundaries without an approved core change.

## Enforcement

`CODEOWNERS`, pull request review, CI, and the GitHub Ruleset in `docs/REPOSITORY_GOVERNANCE.md` support this policy. Only `@odonplay` may merge or directly update `main`; all other contributors use pull requests. The founder remains the final decision maker when a proposed core change has product, architecture, security, QA, or release impact.
