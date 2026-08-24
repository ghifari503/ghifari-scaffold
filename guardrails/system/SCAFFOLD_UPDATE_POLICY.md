# Scaffold Update Policy

## Rule

An active Master Framework must obtain updates only through the pull-only repository at `development/_framework-updater/`, then adopt them through `scripts/update-master-framework.ps1` under `guardrails/system/MASTER_SCAFFOLD_UPDATER_CONTRACT.md`. Never pull in the Master Framework root.

Updating generic governance must never copy, merge, rebase, overwrite, stage, commit, or push files in a Target Project under `development/[project-folder]`. `_framework-updater` is infrastructure and must be excluded from every Target Project route.

## Mandatory Pre-Response Reconciliation

After the Master Framework update is complete and a Target Project has been selected, every runtime must run this command before continuing with any user task:

```powershell
./scripts/reconcile-project-scaffold.ps1 -TargetPath development/[project-folder]
```

Reconciliation verifies the official Master Scaffold origin and clean update source. In an updater-contract Master Framework it is not a second update engine: when updater HEAD is newer than installed `STATE.json`, reconciliation blocks and directs the founder to the exact-report updater flow; when both heads match, it performs target adoption checks without copying generic framework files. Automatic generic synchronization exists only for explicit legacy markers that do not yet declare an updater contract. Legacy synchronization excludes all Target Projects, Master Framework local context (`artifacts/`, `plan/`, `dev-doc/`), Git metadata, and the local workspace marker.

When an explicit framework rollback records `update_status: rolled_back`, reconciliation must fail closed and must not copy generic files. The hold ends only after the founder reviews a new updater dry-run and authorizes its exact report for apply.

It always runs the Target Project adoption check in dry-run mode. It never changes Target Project source, documentation, dependencies, environment, database, Graphify output, Git metadata, branch, index, commits, or remote. A local root-file conflict, invalid baseline, dirty canonical Master Scaffold, or unsafe target adoption result is a blocker: report it and do not continue the requested task until resolved.

The Project Scaffold root remains non-Git throughout this process. Its safe synchronized files and reconciliation marker are local context, never commit candidates.

## Safe Adoption

`scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]` is read-only and reports the precise readiness state.

`-Apply` is allowed only when the target is its own clean Git repository, its client-safe shared facts exist, no legacy copied Master runtime paths are present, the current ODN schema is adopted with status `completed`, and the exact dry-run `report_id` is supplied. Apply creates only one new internal receipt under Project Scaffold `artifacts/traceability-local/[project]/scaffold-updates/`; it never overwrites target work or existing documents.

When the target has no completed adoption for the current ODN schema, every scaffold-update check must also run the read-only `migrate-shared` classification from `scripts/odn-traceability.ps1` or `.sh` and report that migration separately. Ordinary scaffold-update `-Apply` does not authorize ODN removal. ODN apply requires the exact migration report id and the explicit internal-original removal switch, copies and hash-verifies internal state into `artifacts/traceability-local/[project]/`, passes all required migration checks, and only then removes exact internal target files. Client-safe files are never relocated.

The ODN migration is idempotent. It must add prevention rules, scan target Git history, report `HISTORY_PURGE_REQUIRED` when applicable, and never rewrite history automatically.

## Blockers

Block adoption when the target is dirty, lacks shared context, is not a separate repository, is outside `development/`, or contains copied Master runtime paths. Report the blocker and require a separate founder-approved migration plan; never resolve it by overwrite.
