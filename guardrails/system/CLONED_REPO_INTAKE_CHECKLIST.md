# Cloned Repo Intake Checklist

## Purpose
Use this checklist when a repository is cloned, attached, imported, or inherited under scaffold management.

This checklist is mandatory before product-code changes begin inside `development/[project-folder]`.

## Intake Trigger
Run this checklist when any of these is true:
- a repository was freshly cloned
- the founder points the scaffold to an existing project folder
- a new module or service is attached from another repo
- the active branch or upstream source changed materially
- local guardrail files were added or changed since the last intake

## Read Order
Read and inventory local project guidance in this order when present:

1. Repository runtime instructions
   - `AGENTS.md`
   - `CLAUDE.md`
   - `GEMINI.md`
   - `.cursorrules`
   - comparable local instruction files
2. Contribution and onboarding docs
   - `CONTRIBUTING.md`
   - `README.md`
   - setup or onboarding docs
3. Technical manifests and scripts
   - `package.json`
   - `composer.json`
   - Docker or container config
   - workspace config
   - lint, format, and test config
4. Source-structure signals
   - frontend/backend/mobile folders
   - app entrypoints
   - shared libraries
   - migration folders
   - test folders

## Mandatory Intake Outputs
Record these findings in the intake note or readiness baseline:

### 1. Repository Identity
- local path
- remote URL if known
- active branch
- current commit or revision reference
- clean or dirty worktree state

### 2. Runtime Guardrail Inventory
For each local instruction file found, record:
- path
- purpose
- whether it is explicit guidance or only a pointer
- which runtime it primarily targets
- whether it materially affects execution

### 3. Architecture Summary
- frontend stack
- backend stack
- database and cache dependencies
- job, queue, worker, or scheduler behavior
- API shape or service boundaries
- important module or domain boundaries

### 4. Command Inventory
- install command
- local run/dev command
- lint/typecheck command
- unit test command
- integration test command
- E2E/browser test command
- build command

### 5. Codebase Constraints
- forbidden patterns
- required patterns
- naming or folder constraints
- translation or i18n rules
- ORM, DTO, repository, service, or component constraints
- generated-file rules

### 6. Environment And Risk Notes
- required env files or services
- Docker dependency
- data-loss or migration risk
- secrets handling notes
- production-sensitive commands that must not be run casually

### 7. Conflict Scan
- conflicts found: yes or no
- conflicting files
- conflict type
- proposed resolution
- whether founder confirmation is required

## Guardrail Inventory Template
Use this minimum structure in intake evidence when cloned-repo rules exist:

```md
## Local Guardrail Inventory
- File:
- Runtime target:
- Explicit or inferred:
- Key rule:
- Affects:
- Notes:

## Conflict Summary
- Conflict:
- Type:
- Resolution:
- Founder confirmation:
```

## Stop Conditions
Do not start coding, installation, migration, or refactor if any of these remains unresolved:
- local guardrail files were found but not yet read
- the command inventory is still unclear
- allowed write paths do not match the target repository
- a hard conflict exists between scaffold and repository rules
- a repository rule may cause destructive or unsafe behavior

## Handoff Requirement
If intake is paused or handed off, record:
- what was already read
- what still needs to be read
- unresolved conflicts
- commands not yet validated
- whether the repo rules are stable enough for implementation
