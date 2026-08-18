# Scaffold Update Policy

## Rule

Pulling the master scaffold changes master-owned runtime governance for the workspace. It must never automatically copy, merge, rebase, or overwrite files in a target repository under `development/[project-folder]`.

## Safe Adoption

Use `scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]` first. This is read-only and reports the precise readiness state.

`-Apply` is allowed only when the target is its own clean Git repository, its shared context exists, no legacy copied master runtime paths are present, and the exact dry-run `report_id` is supplied. Apply creates only one new receipt under `artifacts/shared/scaffold-updates/`; it never changes target source, existing documents, dependencies, environment, database, or Graphify output.

## Blockers

Block adoption when the target is dirty, lacks shared context, is not a separate repository, is outside `development/`, or contains copied master runtime paths. Report the blocker and require a separate founder-approved migration plan; never resolve it by overwrite.
