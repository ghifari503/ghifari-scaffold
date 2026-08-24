$ErrorActionPreference = 'Stop'
$updaterScript = Join-Path $PSScriptRoot 'update-master-framework.ps1'
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('master-framework-updater-test-' + [guid]::NewGuid().ToString('N'))

function Invoke-Git([string]$Path, [string[]]$Arguments) {
    $previousPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & git -C $Path @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousPreference
    }
    if ($exitCode -ne 0) { throw ('Git failed in {0}: git {1}`n{2}' -f $Path, ($Arguments -join ' '), ($output -join "`n")) }
    return ($output -join "`n").Trim()
}

function Write-Fixture([string]$Root, [string]$RelativePath, [string]$Value) {
    $path = Join-Path $Root $RelativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $path) -Force | Out-Null
    Set-Content -LiteralPath $path -Value $Value -NoNewline
}

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw ('ASSERTION_FAILED: {0}' -f $Message) }
}

try {
    New-Item -ItemType Directory -Path $testRoot -Force | Out-Null
    $seed = Join-Path $testRoot 'seed'
    $framework = Join-Path $testRoot 'framework'
    New-Item -ItemType Directory -Path $seed -Force | Out-Null
    Invoke-Git $seed @('init', '-b', 'main') | Out-Null
    Invoke-Git $seed @('config', 'user.email', 'fixture@example.invalid') | Out-Null
    Invoke-Git $seed @('config', 'user.name', 'Fixture') | Out-Null
    Write-Fixture $seed '.gitignore' "/development/*`n/artifacts/framework-update/`n"
    Write-Fixture $seed 'AGENTS.md' 'legacy generic rules'
    Write-Fixture $seed 'scripts/example.ps1' 'legacy generic script'
    Write-Fixture $seed '.codex/skills/example/SKILL.md' 'legacy generic skill'
    Write-Fixture $seed '.claude/settings.local.json' '{"legacy":true}'
    Write-Fixture $seed 'artifacts/operations/SESSION_LOG.md' 'seed operational state'
    Invoke-Git $seed @('add', '.') | Out-Null
    Invoke-Git $seed @('commit', '-m', 'legacy unversioned baseline') | Out-Null

    & git clone --quiet $seed $framework
    if ($LASTEXITCODE -ne 0) { throw 'Unable to create legacy Master Framework fixture.' }
    Invoke-Git $framework @('config', 'user.email', 'fixture@example.invalid') | Out-Null
    Invoke-Git $framework @('config', 'user.name', 'Fixture') | Out-Null
    Invoke-Git $framework @('remote', 'set-url', 'origin', 'https://github.com/odonplay/odonplay-agent-scaffold.git') | Out-Null

    $isolatedUpdater = Join-Path $framework 'development/_framework-updater'
    New-Item -ItemType Directory -Path (Split-Path -Parent $isolatedUpdater) -Force | Out-Null
    & git clone --quiet $seed $isolatedUpdater
    if ($LASTEXITCODE -ne 0) { throw 'Unable to create isolated updater fixture.' }
    Invoke-Git $isolatedUpdater @('config', 'user.email', 'fixture@example.invalid') | Out-Null
    Invoke-Git $isolatedUpdater @('config', 'user.name', 'Fixture') | Out-Null
    Invoke-Git $isolatedUpdater @('remote', 'set-url', 'origin', 'https://github.com/odonplay/odonplay-agent-scaffold.git') | Out-Null
    Write-Fixture $isolatedUpdater 'AGENTS.md' 'version 5 generic rules'
    Write-Fixture $isolatedUpdater 'scripts/example.ps1' 'version 5 generic script'
    Write-Fixture $isolatedUpdater '.codex/skills/example/SKILL.md' 'version 5 generic skill'
    Write-Fixture $isolatedUpdater '.claude/settings.local.json' '{"upstream":true}'
    Write-Fixture $isolatedUpdater 'SCAFFOLD_VERSION.md' "# Scaffold Version`n`n- version: ``5.0.0``"
    Write-Fixture $isolatedUpdater 'artifacts/operations/SESSION_LOG.md' 'upstream operational state must not copy'
    Invoke-Git $isolatedUpdater @('add', '.') | Out-Null
    Invoke-Git $isolatedUpdater @('commit', '-m', 'release 5 updater') | Out-Null
    Invoke-Git $isolatedUpdater @('update-ref', 'refs/remotes/origin/main', 'HEAD') | Out-Null

    Write-Fixture $framework 'artifacts/operations/SESSION_LOG.md' 'local operational state'
    Write-Fixture $framework 'plan/local-plan.md' 'local plan'
    Write-Fixture $framework 'dev-doc/example/feature/notes.md' 'local development document'
    Write-Fixture $framework '.claude/settings.local.json' '{"local":true}'
    Invoke-Git $framework @('add', 'artifacts/operations/SESSION_LOG.md') | Out-Null

    $workingProject = Join-Path $framework 'development/example-project'
    New-Item -ItemType Directory -Path $workingProject -Force | Out-Null
    Invoke-Git $workingProject @('init', '-b', 'main') | Out-Null
    Invoke-Git $workingProject @('config', 'user.email', 'fixture@example.invalid') | Out-Null
    Invoke-Git $workingProject @('config', 'user.name', 'Fixture') | Out-Null
    Write-Fixture $workingProject 'source.txt' 'working project staged content'
    Invoke-Git $workingProject @('add', 'source.txt') | Out-Null
    $workingIndexBefore = Invoke-Git $workingProject @('diff', '--cached', '--name-only')

    $dryRun = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater | ConvertFrom-Json)
    Assert-True ($dryRun.status -eq 'ready_to_apply') 'Legacy dry-run must be ready.'
    Assert-True ($dryRun.framework_state -eq 'legacy_unversioned') 'Missing version must classify as legacy_unversioned.'
    Assert-True ($dryRun.target_project_mutation -eq 'none') 'Dry-run must promise no Target Project mutation.'
    Assert-True (@($dryRun.changes.path) -contains 'AGENTS.md') 'Generic rule update must be detected.'
    Assert-True (-not (@($dryRun.changes.path) -contains 'artifacts/operations/SESSION_LOG.md')) 'Artifacts must be protected.'

    $applied = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Apply -ReportId $dryRun.report_id | ConvertFrom-Json)
    Assert-True ($applied.status -eq 'applied') 'Apply must succeed.'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $framework '.git'))) 'Master Framework root Git must be inactive after success.'
    Assert-True (@(Get-ChildItem -LiteralPath $framework -Directory -Force | Where-Object Name -like '.git.master-framework-archive-*').Count -eq 1) 'Legacy Git must be archived once.'
    $legacyArchivePath = @(Get-ChildItem -LiteralPath $framework -Directory -Force | Where-Object Name -like '.git.master-framework-archive-*')[0].FullName
    Assert-True ([string]::IsNullOrWhiteSpace((& git --git-dir=$legacyArchivePath diff --cached --name-only))) 'Archived legacy root index must be fully unstaged after success.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'AGENTS.md')) -eq 'version 5 generic rules') 'Generic rules must update.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'artifacts/operations/SESSION_LOG.md')) -eq 'local operational state') 'Local artifacts must be preserved.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'plan/local-plan.md')) -eq 'local plan') 'Local plan must be preserved.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'dev-doc/example/feature/notes.md')) -eq 'local development document') 'Dev-doc must be preserved.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework '.claude/settings.local.json')) -eq '{"local":true}') 'Runtime-local configuration must be preserved.'
    Assert-True ((Invoke-Git $workingProject @('diff', '--cached', '--name-only')) -eq $workingIndexBefore) 'Working Project index must be unchanged.'
    Assert-True (Test-Path -LiteralPath (Join-Path $framework 'artifacts/framework-update/STATE.json')) 'Installed update state must exist.'
    Assert-True (Test-Path -LiteralPath (Join-Path $framework '.project-scaffold.json')) 'Master Framework marker must exist.'
    $installedMarker = Get-Content -Raw -LiteralPath (Join-Path $framework '.project-scaffold.json') | ConvertFrom-Json
    Assert-True ($installedMarker.master_head -eq (Invoke-Git $isolatedUpdater @('rev-parse', 'HEAD'))) 'Marker baseline must match the installed updater HEAD.'

    $repeat = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater | ConvertFrom-Json)
    Assert-True ($repeat.status -eq 'up_to_date') 'A repeated dry-run must be idempotent.'

    Write-Fixture $isolatedUpdater 'AGENTS.md' 'version 5.1 upstream rules'
    Write-Fixture $isolatedUpdater 'SCAFFOLD_VERSION.md' "# Scaffold Version`n`n- version: ``5.1.0``"
    Invoke-Git $isolatedUpdater @('add', 'AGENTS.md', 'SCAFFOLD_VERSION.md') | Out-Null
    Invoke-Git $isolatedUpdater @('commit', '-m', 'release 5.1 updater') | Out-Null
    Invoke-Git $isolatedUpdater @('update-ref', 'refs/remotes/origin/main', 'HEAD') | Out-Null
    Write-Fixture $framework 'AGENTS.md' 'local conflicting rules'
    $blocked = $false
    try { & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater 2>$null | Out-Null } catch { $blocked = $_.Exception.Message -like 'FRAMEWORK_UPDATE_BLOCKED: Local generic conflicts*' }
    Assert-True $blocked 'A changed local generic file must block before mutation.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'AGENTS.md')) -eq 'local conflicting rules') 'Conflict blocking must preserve the local file.'
    Assert-True ((Invoke-Git $workingProject @('diff', '--cached', '--name-only')) -eq $workingIndexBefore) 'Conflict checking must not touch the Working Project index.'

    $rollbackConflictBlocked = $false
    try { & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Rollback -SnapshotId $dryRun.report_id 2>$null | Out-Null } catch { $rollbackConflictBlocked = $_.Exception.Message -like 'FRAMEWORK_UPDATE_BLOCKED: Rollback refused to overwrite a concurrent edit*' }
    Assert-True $rollbackConflictBlocked 'Rollback must not overwrite a generic file edited after apply.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'AGENTS.md')) -eq 'local conflicting rules') 'Blocked rollback must preserve the post-update local edit.'
    Write-Fixture $framework 'AGENTS.md' 'version 5 generic rules'
    $markerPathForTest = Join-Path $framework '.project-scaffold.json'
    $markerBackupForTest = Join-Path $testRoot 'marker-before-local-edit.json'
    Copy-Item -LiteralPath $markerPathForTest -Destination $markerBackupForTest -Force
    $markerBeforeLocalEdit = Get-Content -Raw -LiteralPath $markerPathForTest
    $locallyExtendedMarker = $markerBeforeLocalEdit | ConvertFrom-Json
    $locallyExtendedMarker | Add-Member -NotePropertyName local_note -NotePropertyValue 'preserve me' -Force
    $locallyExtendedMarker | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $framework '.project-scaffold.json')
    $markerRollbackBlocked = $false
    try { & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Rollback -SnapshotId $dryRun.report_id 2>$null | Out-Null } catch { $markerRollbackBlocked = $_.Exception.Message -like '*marker changed after apply*' }
    Assert-True $markerRollbackBlocked 'Rollback must not overwrite non-updater marker properties added after apply.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework '.project-scaffold.json') | ConvertFrom-Json).local_note -eq 'preserve me') 'Blocked rollback must preserve the non-updater marker property.'
    Copy-Item -LiteralPath $markerBackupForTest -Destination $markerPathForTest -Force
    & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Rollback -SnapshotId $dryRun.report_id | ConvertFrom-Json | Out-Null
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $framework '.git'))) 'Deliberate rollback must not reactivate root Git.'
    Assert-True (Test-Path -LiteralPath (Join-Path $framework 'artifacts/framework-update/STATE.json')) 'Rollback must retain a non-Git comparison baseline.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'artifacts/operations/SESSION_LOG.md')) -eq 'local operational state') 'Rollback must preserve local artifacts.'
    Assert-True ((Invoke-Git $workingProject @('diff', '--cached', '--name-only')) -eq $workingIndexBefore) 'Rollback must not touch the Working Project index.'
    $rollbackMarker = Get-Content -Raw -LiteralPath (Join-Path $framework '.project-scaffold.json') | ConvertFrom-Json
    Assert-True ($rollbackMarker.update_status -eq 'rolled_back') 'Rollback must establish a reconciliation hold.'
    $afterRollback = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater | ConvertFrom-Json)
    Assert-True ($afterRollback.status -eq 'ready_to_apply') 'Rollback baseline must support a later safe update.'
    $reapplied = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Apply -ReportId $afterRollback.report_id | ConvertFrom-Json)
    Assert-True ($reapplied.status -eq 'applied') 'The same release path must be safely applicable again after deliberate rollback.'
    Assert-True ($reapplied.snapshot -ne $applied.snapshot) 'Reapply must retain the earlier snapshot and allocate a new snapshot id.'
    Assert-True (-not [string]::IsNullOrWhiteSpace([string]$reapplied.snapshot_id) -and (Split-Path -Leaf $reapplied.snapshot) -eq $reapplied.snapshot_id) 'Reapply must report its allocated rollback snapshot id explicitly.'
    & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Rollback -SnapshotId $reapplied.snapshot_id | ConvertFrom-Json | Out-Null
    $thirdReport = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater | ConvertFrom-Json)
    $reapplied = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Apply -ReportId $thirdReport.report_id | ConvertFrom-Json)
    Assert-True ($reapplied.status -eq 'applied') 'A reapply snapshot id must support rollback followed by another safe apply.'

    $reapplyStatePath = Join-Path $framework 'artifacts/framework-update/STATE.json'
    $validStateText = Get-Content -Raw -LiteralPath $reapplyStatePath
    $craftedState = $validStateText | ConvertFrom-Json
    $craftedState.files | Add-Member -NotePropertyName './development/example-project/.git/config' -NotePropertyValue ('a' * 40) -Force
    $craftedState | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reapplyStatePath
    $unsafeStateBlocked = $false
    try { & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater 2>$null | Out-Null } catch { $unsafeStateBlocked = $_.Exception.Message -like 'FRAMEWORK_UPDATE_BLOCKED: Unsafe updater path*' }
    Assert-True $unsafeStateBlocked 'Dot-prefixed protected paths in installed state must be rejected.'
    Set-Content -LiteralPath $reapplyStatePath -Value $validStateText -NoNewline

    $lockPath = Join-Path $framework 'artifacts/framework-update/.update.lock'
    Set-Content -LiteralPath $lockPath -Value 'foreign lock' -NoNewline
    $lockBlocked = $false
    $currentReport = (& $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater | ConvertFrom-Json)
    try { & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater -Apply -ReportId $currentReport.report_id 2>$null | Out-Null } catch { $lockBlocked = $_.Exception.Message -like 'FRAMEWORK_UPDATE_BLOCKED: A stale update lock*' }
    Assert-True $lockBlocked 'A foreign or stale update lock must block apply.'
    Assert-True (Test-Path -LiteralPath $lockPath -PathType Leaf) 'Updater must never delete a lock it did not acquire.'
    Remove-Item -LiteralPath $lockPath -Force

    $nestedInfrastructure = Join-Path $isolatedUpdater 'development/not-a-project'
    New-Item -ItemType Directory -Path $nestedInfrastructure -Force | Out-Null
    Invoke-Git $nestedInfrastructure @('init', '-b', 'main') | Out-Null
    $frameworkGraphifyScript = Join-Path $framework 'scripts/graphify-status.ps1'
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'graphify-status.ps1') -Destination $frameworkGraphifyScript -Force
    foreach ($route in @(
        @{ name='adoption'; command={ & (Join-Path $PSScriptRoot 'update-scaffold-project.ps1') -RepositoryRoot $framework -TargetPath $nestedInfrastructure } },
        @{ name='reconciliation'; command={ & (Join-Path $PSScriptRoot 'reconcile-project-scaffold.ps1') -ProjectScaffoldPath $framework -TargetPath $nestedInfrastructure -DryRun } },
        @{ name='Graphify'; command={ & $frameworkGraphifyScript -ProjectPath $nestedInfrastructure } }
    )) {
        $routeBlocked = $false
        try { & $route.command 2>$null | Out-Null } catch { $routeBlocked = $_.Exception.Message -like '*framework updater*descendants*' }
        Assert-True $routeBlocked ("{0} must reject every descendant of development/_framework-updater." -f $route.name)
    }
    $previousPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $odnRouteOutput = & node (Join-Path $PSScriptRoot 'odn-traceability.mjs') migrate-shared --master $framework --project nested-infrastructure --target $nestedInfrastructure 2>&1
        $odnRouteExit = $LASTEXITCODE
    } finally { $ErrorActionPreference = $previousPreference }
    Assert-True ($odnRouteExit -ne 0 -and ($odnRouteOutput -join "`n") -like '*framework updater*descendants*') 'ODN must reject every descendant of development/_framework-updater.'

    Write-Fixture $isolatedUpdater 'AGENTS.md' 'version 5.2 upstream rules'
    Write-Fixture $isolatedUpdater 'SCAFFOLD_VERSION.md' "# Scaffold Version`n`n- version: ``5.2.0``"
    Invoke-Git $isolatedUpdater @('add', 'AGENTS.md', 'SCAFFOLD_VERSION.md') | Out-Null
    Invoke-Git $isolatedUpdater @('commit', '-m', 'release 5.2 updater') | Out-Null
    Invoke-Git $isolatedUpdater @('update-ref', 'refs/remotes/origin/main', 'HEAD') | Out-Null
    $frameworkRulesBeforeReconcile = Get-Content -Raw -LiteralPath (Join-Path $framework 'AGENTS.md')
    $reconcileUpdateBlocked = $false
    try { & (Join-Path $PSScriptRoot 'reconcile-project-scaffold.ps1') -ProjectScaffoldPath $framework -TargetPath $workingProject -DryRun 2>$null | Out-Null } catch { $reconcileUpdateBlocked = $_.Exception.Message -like '*framework update is available*' }
    Assert-True $reconcileUpdateBlocked 'Updater-contract reconciliation must block a pulled but unapplied release.'
    Assert-True ((Get-Content -Raw -LiteralPath (Join-Path $framework 'AGENTS.md')) -eq $frameworkRulesBeforeReconcile) 'Reconciliation must never install updater-contract generic files.'

    $archivedFramework = Join-Path $testRoot 'archived-framework'
    & git clone --quiet $seed $archivedFramework
    if ($LASTEXITCODE -ne 0) { throw 'Unable to create archived legacy framework fixture.' }
    $archivedUpdater = Join-Path $archivedFramework 'development/_framework-updater'
    New-Item -ItemType Directory -Path (Split-Path -Parent $archivedUpdater) -Force | Out-Null
    & git clone --quiet $isolatedUpdater $archivedUpdater
    if ($LASTEXITCODE -ne 0) { throw 'Unable to create archived framework updater fixture.' }
    Invoke-Git $archivedUpdater @('remote', 'set-url', 'origin', 'https://github.com/odonplay/odonplay-agent-scaffold.git') | Out-Null
    $archiveName = '.git.project-scaffold-archive-fixture'
    Move-Item -LiteralPath (Join-Path $archivedFramework '.git') -Destination (Join-Path $archivedFramework $archiveName)
    [ordered]@{
        workspace_type = 'project_scaffold'
        canonical_master_scaffold = 'D:\canonical-fixture'
        git_root_status = 'archived_local_not_a_commit_source'
        git_archive = $archiveName
    } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $archivedFramework '.project-scaffold.json')
    $archivedDryRun = (& $updaterScript -FrameworkRoot $archivedFramework -UpdaterPath $archivedUpdater | ConvertFrom-Json)
    Assert-True ($archivedDryRun.baseline_mode -eq 'legacy_archived_root_git') 'Archived root Git must supply a legacy baseline.'
    & $updaterScript -FrameworkRoot $archivedFramework -UpdaterPath $archivedUpdater -Apply -ReportId $archivedDryRun.report_id | ConvertFrom-Json | Out-Null
    $archivedMarker = Get-Content -Raw -LiteralPath (Join-Path $archivedFramework '.project-scaffold.json') | ConvertFrom-Json
    Assert-True ($archivedMarker.canonical_master_scaffold -eq 'D:\canonical-fixture') 'Existing marker fields must survive adoption.'
    Assert-True ($archivedMarker.update_status -eq 'completed') 'Archived legacy adoption must record completion.'

    $worktreeFramework = Join-Path $testRoot 'linked-worktree-framework'
    Invoke-Git $seed @('worktree', 'add', '--detach', $worktreeFramework, 'HEAD') | Out-Null
    $worktreeUpdater = Join-Path $worktreeFramework 'development/_framework-updater'
    New-Item -ItemType Directory -Path (Split-Path -Parent $worktreeUpdater) -Force | Out-Null
    & git clone --quiet $isolatedUpdater $worktreeUpdater
    if ($LASTEXITCODE -ne 0) { throw 'Unable to create linked-worktree updater fixture.' }
    Invoke-Git $worktreeUpdater @('remote', 'set-url', 'origin', 'https://github.com/odonplay/odonplay-agent-scaffold.git') | Out-Null
    $worktreeBlocked = $false
    try { & $updaterScript -FrameworkRoot $worktreeFramework -UpdaterPath $worktreeUpdater 2>$null | Out-Null } catch { $worktreeBlocked = $_.Exception.Message -like '*linked-worktree .git file is unsupported*' }
    Assert-True $worktreeBlocked 'A linked-worktree Master Framework root must fail closed before index or Git metadata mutation.'

    $canonicalBlocked = $false
    try { & $updaterScript -FrameworkRoot 'E:\www\project-scaffold' -UpdaterPath $isolatedUpdater 2>$null | Out-Null } catch { $canonicalBlocked = $_.Exception.Message -like 'FRAMEWORK_UPDATE_BLOCKED: The canonical Master Scaffold*' }
    Assert-True $canonicalBlocked 'Canonical Master Scaffold must be rejected.'

    $canonicalAlias = Join-Path $testRoot 'canonical-alias'
    New-Item -ItemType Junction -Path $canonicalAlias -Target 'E:\www\project-scaffold' | Out-Null
    try {
        $canonicalAliasBlocked = $false
        try { & $updaterScript -FrameworkRoot $canonicalAlias -UpdaterPath $isolatedUpdater 2>$null | Out-Null } catch { $canonicalAliasBlocked = $_.Exception.Message -like '*cannot be a junction*' }
        Assert-True $canonicalAliasBlocked 'A junction alias must be rejected before it can be retargeted between dry-run and apply.'
    } finally { if (Test-Path -LiteralPath $canonicalAlias) { [IO.Directory]::Delete($canonicalAlias) } }

    $frameworkArtifacts = Join-Path $framework 'artifacts'
    $externalArtifacts = Join-Path $testRoot 'redirected-framework-artifacts'
    Move-Item -LiteralPath $frameworkArtifacts -Destination $externalArtifacts
    New-Item -ItemType Junction -Path $frameworkArtifacts -Target $externalArtifacts | Out-Null
    try {
        $metadataJunctionBlocked = $false
        try { & $updaterScript -FrameworkRoot $framework -UpdaterPath $isolatedUpdater 2>$null | Out-Null } catch { $metadataJunctionBlocked = $_.Exception.Message -like 'FRAMEWORK_UPDATE_BLOCKED: Reparse point*' }
        Assert-True $metadataJunctionBlocked 'Updater-owned metadata must not traverse an artifacts junction.'
    } finally {
        if (Test-Path -LiteralPath $frameworkArtifacts) { [IO.Directory]::Delete($frameworkArtifacts) }
        Move-Item -LiteralPath $externalArtifacts -Destination $frameworkArtifacts
    }

    'MASTER_FRAMEWORK_UPDATER_TESTS_PASS'
} finally {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
}
