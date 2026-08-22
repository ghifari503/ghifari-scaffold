# Client-Safe Project State Baseline

This file is part of the target project contract. Include verified, non-sensitive project facts only. Do not include active work, lifecycle, handoff, routing, contributor/process, development-state, runtime/model, or internal traceability metadata.

- traceability_class: `client_safe`

## Project Purpose And Boundary

- target_project: `[project-folder]`
- purpose: `[verified summary or unknown]`
- supported_by:
  - `[client-safe source path]`
- in_scope_systems:
  - `[system]`
- verified_unknowns:
  - `[unknown without internal work-state detail]`

## Stack And Local Commands

| Area | Verified Finding | Evidence |
|---|---|---|
| Package manager |  |  |
| Execution environment / version |  |  |
| Frontend |  |  |
| Backend / worker |  |  |
| Database / storage |  |  |
| Test stack |  |  |
| Build command |  |  |
| Run command |  |  |

## Public System Map

- entrypoints:
  - `[path and role]`
- module_roots:
  - `[path and responsibility]`
- route_or_api_map:
  - `[route/endpoint and source path]`
- data_and_integration_boundaries:
  - `[boundary and source path]`
- auth_or_security_boundaries:
  - `[non-sensitive boundary and source path]`
- configuration_and_environment_requirements:
  - `[non-secret requirement and source path]`

## Client-Safe Constraints

- known_project_constraints:
  - `[verified contract or technical constraint]`
- known_public_compatibility_requirements:
  - `[requirement and evidence]`

Internal continuation belongs only in Master Scaffold `artifacts/traceability/[project]/`.
