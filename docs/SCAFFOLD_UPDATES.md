# Safe Master Scaffold Updates

After `git pull` in the master scaffold, active projects keep their own Git history and working files. The updated master rules apply to future runtime work in the workspace; they are not copied into target repositories.

To record an opt-in adoption safely:

```powershell
./scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder]
```

Review the JSON dry-run result. Only when status is `ready_for_opt_in_apply`, run the displayed report id:

```powershell
./scripts/update-scaffold-project.ps1 -TargetPath development/[project-folder] -Apply -ReportId [report-id]
```

The apply action creates one new receipt only. It fails closed for dirty projects, missing shared context, legacy copied scaffold files, invalid target paths, or an existing receipt.
