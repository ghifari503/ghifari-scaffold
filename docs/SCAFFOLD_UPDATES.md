# Safe Master Scaffold Updates

After `git pull` in the master scaffold, active projects keep their own Git history and working files. The updated master rules apply to future runtime work in the workspace; they are not copied into target repositories.

To record an opt-in adoption safely:

```powershell
./scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]
```

If the result reports incomplete ODN schema adoption, first review its embedded migration dry-run or run it directly:

```powershell
./scripts/odn-traceability.ps1 migrate-shared --project [project-folder] --target development/[project-folder]
```

A future real migration apply requires its exact report id and the explicit `--remove-internal-originals` switch. Ordinary scaffold update apply never authorizes that removal.

After the Master Scaffold migration receipt is complete and the target working tree is clean, rerun the update dry-run. Only when status is `ready_for_opt_in_apply`, run the displayed update report id:

```powershell
./scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder] -Apply -ReportId [report-id]
```

The apply action creates one new internal Master Scaffold receipt only. It fails closed for dirty projects, missing client-safe shared facts, incomplete current ODN schema adoption, legacy copied scaffold files, invalid target paths, or an existing receipt.
