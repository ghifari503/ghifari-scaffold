# Contributing To The Odonplay Agent Scaffold

## Purpose

Teams may extend this scaffold for Odonplay work while preserving its protected workflow. Read `AGENTS.md`, `SCAFFOLD_WORKFLOW.md`, and `guardrails/system/SCAFFOLD_CORE_CHANGE_POLICY.md` before proposing a change.

## Contribution Types

- Project extensions: add project-specific docs, dev-doc, templates, skills, or target-repository work without weakening scaffold gates.
- Runtime skills and agents: add a complete normalized skill to both `.codex/skills/` and `.claude/skills/`, then run `cek skill`.
- Protected workflow changes: changes to runtime rules, guardrails, workflow gates, templates, shared-context requirements, QA policy, or release controls.

## Required Process

1. Do not push directly to `main`. Only `@odonplay` may update `main` after required review and CI checks.
2. Create a focused branch from `main`.
3. Keep one logical change per pull request.
4. Read relevant guardrails, context, and templates before editing.
5. Update documentation and artifacts required by the change scope.
6. Run `scripts/check-skills.ps1` on Windows or `scripts/check-skills.sh` on Unix when skills change.
7. Complete the pull request checklist and address CI findings.
8. Obtain required CODEOWNERS review for protected workflow changes. Only `@odonplay` merges or pushes the approved result to `main`.

Repository administrators must apply the server-side branch rules in `docs/REPOSITORY_GOVERNANCE.md`; `CODEOWNERS` alone does not block direct pushes.

## Protected Workflow Rule

Do not bypass, weaken, remove, or silently replace mandatory gates. This includes plan approval, skill lookup, dev-doc discovery, pre-coding, shared context, QA evidence, documentation sync, handoff, and founder release decisions.

When a team needs a different project implementation pattern, extend the project-specific layer instead of changing scaffold core behavior. Use a core-flow change proposal only when a genuine scaffold-wide improvement is required.

## Security And Secrets

Never commit secrets, credentials, `.env` values, production access, raw personal data, or raw automation output. Report security concerns using `SECURITY.md`.
