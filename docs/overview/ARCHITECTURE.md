# ARCHITECTURE

This document is the high-level system overview for the `project-scafold` repository.

## Purpose
This scaffold is not a finished product application. Its purpose is to act as an operating system for onboarding, auditing, and evolving software or software+IoT projects that already exist.

## System Role
The scaffold provides:
- runtime operating rules for Codex and Claude
- persistent project context and status documents
- existing-project intake and impact-scan workflows
- planning, design, build, QA, and release workflows
- skills and agents mapped to official steps
- artifact templates for requirements, architecture, testing, and release
- scripts for development routing, framework activation, and scaffold execution when approved

## High-Level Structure
- `AGENTS.md`
  Primary runtime rules for Codex.
- `CLAUDE.md`
  Compatibility rules for Claude.
- `docs/`
  Overview and navigation entry points.
- `guardrails/`
  Strict rules, policies, protocols, standards, and guides.
- `artifacts/`
  Project state, context, logs, decisions, and formal outputs.
- `templates/`
  Reusable document templates and implementation blueprints.
- `workflows/`
  Existing-project onboarding flow plus incremental delivery flows.
- `scripts/`
  Automation for skill sync, activation, scaffold preparation, and setup.
- `.claude/skills/` and `.codex/skills/`
  Operational skills used to execute official steps.
- `development/`
  An intentionally empty placeholder that can later receive imported or approved scaffold structure if needed.

## Architecture Principles
- Existing-project-first delivery.
- Understand the current system before changing it.
- Preserve current frameworks and conventions unless the founder approves a change.
- Frontend-first validation still applies when UI behavior changes.
- Architecture decisions must map to a concrete development route.
- Only one implementation route may be active at a time.
- Release readiness cannot be declared without QA evidence.

## Operating Flow
1. Onboarding:
   - existing project intake
   - stack and route audit
   - impact scan
2. Planning:
   - founder interview when needed
   - requirement delta
   - flow delta
   - design delta
   - architecture delta
   - sprint planning
3. Build:
   - frontend build when UI is involved
   - API contract delta finalization
   - backend build
   - IoT build if relevant
4. Review and Release:
   - code review
   - QA testing
   - release preparation
   - release check
5. Improvement:
   - learning capture
   - improvement planning

## State Management
Operational state mainly lives in:
- `artifacts/operations/WORKFLOW_STATE.md`
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/CURRENT_TASK.md`
- `artifacts/architecture/DECISION_LOG.md`
- `artifacts/operations/SESSION_LOG.md`
- `artifacts/improvement/LEARNINGS.md`

## Governance Split
- `guardrails/` controls how the model should behave.
- `artifacts/` records what the project currently is, what has happened, and what has been produced.
- `docs/` helps humans and runtimes find the right entry points quickly.

## Design and API Artifact Model
- Design artifacts:
  `dev-doc/[feature-name]/design/[page]/[section]/[sub-section]/`
- General mixed design references:
  `artifacts/design/master-ui-templates/`
- API specs:
  `artifacts/architecture/api-specs/`
- Test evidence:
  `artifacts/test/`
- Release artifacts:
  `artifacts/release/`

## Development Route Model
The real implementation architecture may already exist before this scaffold is adopted. During onboarding:
- confirm `architecture_style`
- confirm `development_route`
- confirm active frontend root
- confirm active backend root
- confirm active shared contracts root

If the current route remains valid, keep it and document it.
If the route must change, record an explicit architecture decision before moving implementation.
Do not prefill `development/` with fake structure before intake confirms the target route.

## What This Scaffold Is Not
- Not a ready-to-run product monorepo.
- Not a mandate to replace the existing stack.
- Not a reason to rewrite a working system without a founder-approved decision.

## Initial Architecture Status
- Architecture style: `not_selected`
- Development route: `not_selected`
- Frontend framework: `not_selected`
- Backend framework: `not_selected`
- Database: `not_selected`
- Testing stack: `not_selected`

## Recommended Next Architecture Action
Run the existing-project onboarding flow first.
After the impact scan and requirement delta are clear, run step `P6 Solution Architecture` only if the requested change affects:
- system boundaries
- module boundaries
- data ownership
- sync rules
- security constraints
- development route

