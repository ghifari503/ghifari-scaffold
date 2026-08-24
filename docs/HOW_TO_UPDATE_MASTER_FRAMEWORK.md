# How to Update a Master Framework

This guide applies to an active Master Framework containing local state and Working Projects. It does not apply to the canonical Master Scaffold used to publish releases.

## What Stays Untouched

The update does not modify Working Projects, their Git state, Master Framework logs, memory, traceability, operational artifacts, `plan/`, `dev-doc/`, or local runtime configuration. The only writable artifacts area is updater-owned `artifacts/framework-update/`, where update state, locks, and recoverable snapshots stay local and never enter Git.

## First Update From a Legacy Framework

Open PowerShell in the Master Framework root. Do not run `git pull` in that root.

Clone the isolated updater once:

```powershell
git clone --filter=blob:none --single-branch --branch main https://github.com/odonplay/odonplay-agent-scaffold.git development/_framework-updater
```

Trust only a clone obtained directly through the official GitHub URL. Do not receive this folder as ZIP/chat transfer, change its origin, create local commits, or rewrite `refs/remotes/origin/main`.

Then open or resume the runtime and type:

```text
update framework
```

The runtime recognizes a missing version as `legacy_unversioned`, runs a dry-run, shows the report, and requests confirmation before apply.

## Routine Update

Obtain the latest updater code:

```powershell
git -C development/_framework-updater pull --ff-only origin main
```

Then type `update framework`. If no newer update has been obtained, startup does not offer the update prompt.

## Manual Dry-Run

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot .
```

Review `status`, `framework_state`, `changes`, `protected_roots`, `target_project_mutation`, and `report_id`. Status must be `ready_to_apply` or `up_to_date`; target mutation must be `none`.

## Manual Apply

Use the exact report id returned by the current dry-run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot . -Apply -ReportId [report-id]
```

On success, the result reports `status: applied`. A legacy root Git directory is fully unstaged and archived only after copied files pass validation. The root then remains non-Git; the updater and Working Projects remain independent repositories.

## If the Update Is Blocked

The updater stops when a generic file changed both locally and upstream, the updater is dirty or has the wrong origin, the baseline is missing or divergent, the report id is stale, the canonical Master Scaffold was selected, or validation fails.

Do not use `reset --hard`, force checkout, automatic merge, or delete root Git. Give the reported paths to the founder and decide explicitly which version should control them.

## Rollback

Failed apply operations roll back automatically. A deliberate rollback keeps root Git inactive:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File development/_framework-updater/scripts/update-master-framework.ps1 -FrameworkRoot . -Rollback -SnapshotId [snapshot-id]
```

Use the exact `snapshot_id` returned by the successful apply, not its dry-run `report_id`. The snapshot path also ends with this id. Use deliberate rollback only after founder approval. It does not modify Working Projects.

Rollback refuses to overwrite a generic file edited after the update. A successful rollback sets a hold that prevents reconciliation from silently applying the same release again. To update afterward, obtain the desired release, run a new dry-run, review its new report, and authorize apply again.

## Commands That Must Not Be Used

Never update an active Master Framework with `git pull origin main`, `git reset --hard origin/main`, or `git checkout -- .` from its root. Those commands bypass isolated dry-run, snapshot, conflict, and rollback controls.
