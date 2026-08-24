# Safe Scaffold Updates

There are two separate operations:

1. Update the Master Framework root from the isolated pull-only repository. Follow `docs/HOW_TO_UPDATE_MASTER_FRAMEWORK.md`.
2. Reconcile a selected Working Project after the framework update. This remains read-only for the Working Project.

After a successful Master Framework update, reconcile the selected Working Project:

```powershell
./scripts/reconcile-project-scaffold.ps1 -TargetPath development/[project-folder]
```

For a v5 updater-contract Master Framework, reconciliation never installs a pulled release. If updater HEAD is newer than local installed state, it blocks until the founder reviews and applies the exact updater report described in [How to Update a Master Framework](HOW_TO_UPDATE_MASTER_FRAMEWORK.md). Generic root synchronization remains available only for legacy markers during migration.

Reconciliation uses the isolated updater as its generic source, synchronizes only unchanged Master Framework root files, and then runs a read-only Target Project adoption check. It never modifies or commits a Working Project.

To inspect opt-in Target Project adoption:

```powershell
./scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]
```

If it reports incomplete ODN schema adoption, inspect its separate migration dry-run:

```powershell
./scripts/odn-traceability.ps1 migrate-shared --project [project-folder] --target development/[project-folder]
```

ODN migration apply and the ordinary adoption receipt remain separate founder-approved actions. Neither is authorized by `update framework`.
