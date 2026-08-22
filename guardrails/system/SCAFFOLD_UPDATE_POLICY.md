# Scaffold Update Policy

## Rule

Pulling the master scaffold changes master-owned runtime governance for the workspace. It must never automatically copy, merge, rebase, or overwrite files in a target repository under `development/[project-folder]`.

## Safe Adoption

Use `scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]` first. This is read-only and reports the precise readiness state.

`-Apply` is allowed only when the target is its own clean Git repository, its client-safe shared facts exist, no legacy copied master runtime paths are present, the current ODN schema is adopted with status `completed`, and the exact dry-run `report_id` is supplied. Apply creates only one new internal receipt under Master Scaffold `artifacts/traceability/[project]/scaffold-updates/`; it never changes target source, existing documents, dependencies, environment, database, or Graphify output.

When the target has no completed adoption for the current ODN schema, every scaffold-update check must also run the read-only `migrate-shared` classification from `scripts/odn-traceability.ps1` or `.sh` and report that migration separately. Ordinary scaffold-update `-Apply` does not authorize ODN removal. ODN apply requires the exact migration report id and the explicit internal-original removal switch, copies and hash-verifies internal state into `artifacts/traceability/[project]/`, passes all required migration checks, and only then removes exact internal target files. Client-safe files are never relocated.

The ODN migration is idempotent. It must add prevention rules, scan target Git history, report `HISTORY_PURGE_REQUIRED` when applicable, and never rewrite history automatically.

## Blockers

Block adoption when the target is dirty, lacks shared context, is not a separate repository, is outside `development/`, or contains copied master runtime paths. Report the blocker and require a separate founder-approved migration plan; never resolve it by overwrite.
