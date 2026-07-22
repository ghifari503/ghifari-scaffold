# Development Structure Routing

This document defines how the scaffold records and uses the real development route of an existing project.

## Purpose

- Prevent the scaffold from forcing a fake folder layout before intake is done
- Tie the approved architecture decision to the actual implementation paths used by the existing codebase
- Keep frontend and backend generation consistent across Codex/GPT, Claude, and Gemini

## Core Rule

For `project-scafold`, the `development/` folder starts empty until a target repository is attached.

Once the target repository is cloned or attached, it should live under `development/[project-folder]` and that folder becomes the active workspace.

It is not pre-filled with route templates because:
- the existing project may already have its own structure
- the correct route must be confirmed from repo intake, not guessed

## What Must Be Recorded

After intake or architecture confirmation, the system must record:

- `architecture_style`
- `development_route`
- `active_frontend_root`
- `active_backend_root`
- `active_shared_contracts_root`

These values are stored in:
- `artifacts/operations/CURRENT_PHASE.md`
- `artifacts/operations/WORKFLOW_STATE.md`

## Allowed Route Styles

### Monolith Modular
Use when the existing project behaves like a modular monolith, even if the folder names are custom.

Example route registration:

```text
architecture_style: monolith_modular
development_route: apps
active_frontend_root: apps/web/src
active_backend_root: apps/api/src
active_shared_contracts_root: packages/contracts
```

### Microservice
Use when the existing project separates services with independent service boundaries.

Example route registration:

```text
architecture_style: microservice
development_route: services
active_frontend_root: apps/web/src
active_backend_root: services
active_shared_contracts_root: packages/contracts
```

### Custom
Use when the existing project does not cleanly fit the standard route labels.

Example route registration:

```text
architecture_style: custom
development_route: legacy-platform
active_frontend_root: client/app
active_backend_root: server
active_shared_contracts_root: shared/types
```

## Build Start Rule

Before builders begin:

1. Read the current project intake
2. Read the confirmed route values
3. Work inside `development/[project-folder]` for the attached repo
4. Write only into the confirmed active roots
5. Do not assume a different root is the live target unless intake explicitly says so

## Empty Development Folder Rule

`development/` is intentionally empty at scaffold start.

Use it only when:
- you intentionally clone or attach the existing project structure there
- you create a controlled mirrored route there
- the founder explicitly approves a new scaffold target under `development/`

Until then, it remains a placeholder directory, not an active implementation target.

## Activation Helpers

After intake confirms the real paths, register them with:

- PowerShell:
  - `scripts/activate-development-route.ps1 -ArchitectureStyle custom -DevelopmentRoute client-server -FrontendRoot client/app -BackendRoot server -SharedContractsRoot shared/types`
- Bash:
  - `bash scripts/activate-development-route.sh custom client-server client/app server shared/types`

## Unit Scaffolding Helpers

After the route is registered, create scoped folders inside the active roots with:

- PowerShell:
  - `scripts/create-development-unit.ps1 -Kind frontend-page -Name auth-login`
  - `scripts/create-development-unit.ps1 -Kind backend-unit -Name auth`
  - `scripts/create-development-unit.ps1 -Kind shared-package -Name billing-contracts`
- Bash:
  - `bash scripts/create-development-unit.sh frontend-page auth-login`
  - `bash scripts/create-development-unit.sh backend-unit auth`
  - `bash scripts/create-development-unit.sh shared-package billing-contracts`

