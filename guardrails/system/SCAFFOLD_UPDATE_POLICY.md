# Scaffold Update Policy

## Rule

Pulling the Master Scaffold updates generic governance only. It must never copy, merge, rebase, overwrite, stage, commit, or push files in a Target Project under `development/[project-folder]`.

## Mandatory Pre-Response Reconciliation

When a Project Scaffold is active and a Target Project has been selected, every runtime must run this command before continuing with any user task:

```powershell
./scripts/reconcile-project-scaffold.ps1 -TargetPath development/[project-folder]
```

The reconciliation verifies the official Master Scaffold origin and a clean canonical source. It automatically synchronizes only changed generic Master Scaffold files into the Project Scaffold root when those local files are unchanged since the archived baseline. It excludes all Target Projects, Project Scaffold local context (`artifacts/`, `plan/`, `dev-doc/`), Git metadata, and the local workspace marker.

It always runs the Target Project adoption check in dry-run mode. It never changes Target Project source, documentation, dependencies, environment, database, Graphify output, Git metadata, branch, index, commits, or remote. A local root-file conflict, invalid baseline, dirty canonical Master Scaffold, or unsafe target adoption result is a blocker: report it and do not continue the requested task until resolved.

The Project Scaffold root remains non-Git throughout this process. Its safe synchronized files and reconciliation marker are local context, never commit candidates.

## Safe Adoption

`scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]` is read-only and reports the precise readiness state.

`-Apply` is allowed only when the target is its own clean Git repository, its client-safe shared facts exist, no legacy copied Master runtime paths are present, the current ODN schema is adopted with status `completed`, and the exact dry-run `report_id` is supplied. Apply creates only one new internal receipt under Project Scaffold `artifacts/traceability-local/[project]/scaffold-updates/`; it never overwrites target work or existing documents.

When the target has no completed adoption for the current ODN schema, every scaffold-update check must also run the read-only `migrate-shared` classification from `scripts/odn-traceability.ps1` or `.sh` and report that migration separately. Ordinary scaffold-update `-Apply` does not authorize ODN removal. ODN apply requires the exact migration report id and the explicit internal-original removal switch, copies and hash-verifies internal state into `artifacts/traceability-local/[project]/`, passes all required migration checks, and only then removes exact internal target files. Client-safe files are never relocated.

The ODN migration is idempotent. It must add prevention rules, scan target Git history, report `HISTORY_PURGE_REQUIRED` when applicable, and never rewrite history automatically.

## Blockers

Block adoption when the target is dirty, lacks shared context, is not a separate repository, is outside `development/`, or contains copied Master runtime paths. Report the blocker and require a separate founder-approved migration plan; never resolve it by overwrite.
