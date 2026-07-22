# Code-Derived Baseline Policy

## Purpose

Create a durable, Git-carried project baseline when an attached target repository has no usable BRD, PRD, `dev-doc/`, README, architecture note, API specification, or other relevant documentation.

The baseline lets future agents and developers continue from verified project context without rediscovering the entire codebase. It is evidence-backed context, not a replacement for current source code.

## When This Policy Applies

Apply this policy during the first `I1 Existing Project Intake` for a target repository under `development/[project-folder]` when targeted documentation discovery finds no relevant project documentation.

It also applies when the available documents are materially stale, contradictory, or too incomplete to establish the current project state. Record the reason in the baseline.

## Mandatory Documentation Question

Before deriving a baseline from code, search targeted likely documentation locations, including repository root documentation, `docs/`, `dev-doc/`, architecture/API/design notes, setup guides, and documentation named by the founder or existing project configuration.

If no relevant documentation is found, ask the founder exactly this question before source-derived baseline work:

> Apakah ada dokumen, link, diagram, akses repository lain, atau konteks lain yang dapat saya gunakan sebagai referensi untuk memahami project ini?

Record the founder response in `PROJECT_STATE.md`.

- If the founder provides material, read it first and record it as a baseline source.
- If the founder confirms there is no material, or does not provide relevant material, continue with the code-derived baseline.
- The question does not open implementation permission and does not replace the normal founder interview when product intent remains unclear.

## Required Baseline Artifacts

During first intake, create and maintain these Git-safe target-repository files:

- `development/[project-folder]/artifacts/shared/PROJECT_STATE.md` from `templates/shared_project_state_template.md`
- `development/[project-folder]/artifacts/shared/ACTIVE_CONTEXT.md`
- `development/[project-folder]/artifacts/shared/CONTRIBUTOR_LOG.md`

Then use `memory-curator` to capture stable, verified facts from the completed intake baseline in scaffold memory:

- `artifacts/memory/MEMORY_LEDGER.toml`
- `artifacts/memory/MEMORY_INDEX.md`
- `artifacts/memory/FEATURE_REGISTRY.toml` and `FEATURE_REGISTRY.md` when features or modules are confirmed
- matching memory category files and `MEMORY_CHANGELOG.md` when applicable

## Required PROJECT_STATE Content

Every code-derived baseline must contain source-linked, confidence-labeled findings for:

- documentation discovery result and founder response
- project purpose only when supported by evidence; otherwise mark as `unknown`
- technology stack, package manager, runtime, build and test commands
- frontend, backend, worker, mobile, device, database, and infrastructure roots when present
- application entrypoints, route or API map, and major module boundaries
- important data flow, integration boundaries, schemas, queues, scheduled jobs, or device flows when present
- authentication/authorization approach and security-sensitive boundaries when identifiable
- key configuration and environment requirements without storing secrets
- known failures, constraints, technical debt, and uncertainty
- source paths, commands, or artifacts supporting each significant finding
- suggested targeted scan paths for common future tasks

Do not infer business requirements, ownership, production state, secrets, or undocumented behavior from filenames or model guesswork. Mark uncertainty explicitly.

## Token-Efficient Discovery Order

1. Read existing shared context and active operational state.
2. Perform targeted documentation discovery and ask the mandatory documentation question only when it finds no relevant material.
3. Read manifest files, package scripts, lockfiles, runtime/version files, and top-level configuration.
4. Identify entrypoints, route definitions, API contracts, schemas, and test configuration from those anchors.
5. Scan only the module roots and adjacent files named by those anchors.
6. Expand to cross-module or repository-wide scanning only when first `I1` needs it, the initial evidence conflicts, a critical boundary remains unknown, or a documented risk requires it.
7. Store concise evidence summaries and paths. Do not place raw source dumps, full logs, secrets, or long generated output in the baseline or memory.

Token efficiency never permits omission of a required baseline category when relevant evidence exists. If a category cannot be established, record `unknown`, the targeted paths checked, and the next discovery action.

## Recall And Refresh Rules

Before future source scanning, agents must read `PROJECT_STATE.md`, relevant shared context, relevant feature registry entries, and only the memory entries relevant to the current task.

Use the baseline to select targeted paths. Do not rediscover the whole repository when the baseline already identifies the relevant module, route, or integration boundary.

Refresh `PROJECT_STATE.md` after meaningful architecture, stack, route/API, module-boundary, integration, or environment changes. If current source conflicts with the baseline, follow current source, record the discrepancy, and synchronize affected memory entries.

## Completion And Stop Rules

First intake is not complete or `resume_safe` when documentation is absent until:

- the mandatory documentation question and response are recorded;
- `PROJECT_STATE.md` contains the required evidence-backed baseline or documented unknowns;
- `ACTIVE_CONTEXT.md` and `CONTRIBUTOR_LOG.md` identify the baseline and next step; and
- relevant verified facts are synchronized into scaffold memory.

Stop and record a blocker instead of claiming baseline completion if the target repository cannot be read, documentation question is still awaiting a founder response, or critical project state remains unknown after the allowed targeted discovery.

