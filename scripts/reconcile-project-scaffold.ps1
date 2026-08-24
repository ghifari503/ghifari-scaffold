[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string]$TargetPath,
    [string]$ProjectScaffoldPath,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$officialMasterRemote = 'https://github.com/odonplay/odonplay-agent-scaffold.git'

function Stop-Reconciliation([string]$Message) { throw ('SCAFFOLD_RECONCILIATION_BLOCKED: {0}' -f $Message) }
function Get-GitText([string]$Path, [string[]]$Arguments) {
    $result = & git -C $Path @Arguments 2>$null
    if ($LASTEXITCODE -ne 0) { return $null }
    return ($result -join [Environment]::NewLine).Trim()
}
function Normalize-Path([string]$Path) { return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path.TrimEnd('\', '/') }
function Normalize-Remote([string]$Remote) {
    if ([string]::IsNullOrWhiteSpace($Remote)) { return '' }
    $normalized = $Remote.Trim().TrimEnd('/')
    if ($normalized.EndsWith('.git', [StringComparison]::OrdinalIgnoreCase)) { $normalized = $normalized.Substring(0, $normalized.Length - 4) }
    if ($normalized -eq 'git@github.com:odonplay/odonplay-agent-scaffold') { return 'https://github.com/odonplay/odonplay-agent-scaffold' }
    return $normalized.ToLowerInvariant()
}
function Is-Descendant([string]$Child, [string]$Parent) {
    $prefix = $Parent.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    return $Child.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)
}
function Is-SynchronizablePath([string]$RelativePath) {
    $normalized = $RelativePath.Replace('\', '/')
    if ($normalized -eq '.project-scaffold.json' -or $normalized -like '.git*') { return $false }
    if ($normalized -like 'artifacts/*' -or $normalized -like 'plan/*' -or $normalized -like 'dev-doc/*') { return $false }
    if ($normalized -like 'development/*' -and -not $normalized.StartsWith('development/_project-template/')) { return $false }
    return $true
}

if ([string]::IsNullOrWhiteSpace($ProjectScaffoldPath)) { $ProjectScaffoldPath = Split-Path -Parent $PSScriptRoot }
$projectScaffold = Normalize-Path $ProjectScaffoldPath
$markerPath = Join-Path $projectScaffold '.project-scaffold.json'
if (-not (Test-Path -LiteralPath $markerPath -PathType Leaf)) { Stop-Reconciliation 'Project Scaffold marker is missing.' }
$marker = Get-Content -Raw -LiteralPath $markerPath | ConvertFrom-Json
if ($marker.workspace_type -ne 'project_scaffold') { Stop-Reconciliation 'Workspace marker is not a Project Scaffold.' }
if (Test-Path -LiteralPath (Join-Path $projectScaffold '.git')) { Stop-Reconciliation 'Project Scaffold root Git must remain inactive.' }
if ([string]$marker.update_status -eq 'rolled_back') { Stop-Reconciliation 'Framework rollback hold is active. Reconciliation cannot reapply generic files; run a new founder-approved framework updater dry-run and apply.' }

$sourceReference = if (-not [string]::IsNullOrWhiteSpace([string]$marker.master_scaffold_update_source)) { [string]$marker.master_scaffold_update_source } else { [string]$marker.canonical_master_scaffold }
if ([string]::IsNullOrWhiteSpace($sourceReference)) { Stop-Reconciliation 'Master Scaffold update source is missing from the workspace marker.' }
$sourceCandidate = if ([IO.Path]::IsPathRooted($sourceReference)) { $sourceReference } else { Join-Path $projectScaffold $sourceReference }
$canonicalMaster = Normalize-Path $sourceCandidate
if ($canonicalMaster -eq $projectScaffold) { Stop-Reconciliation 'Canonical Master Scaffold cannot be reconciled as a Project Scaffold.' }
$canonicalGitRoot = Get-GitText $canonicalMaster @('rev-parse', '--show-toplevel')
if ([string]::IsNullOrWhiteSpace($canonicalGitRoot) -or (Normalize-Path $canonicalGitRoot) -ne $canonicalMaster) { Stop-Reconciliation 'Configured Master Scaffold update source is not its own Git repository.' }
$remote = Get-GitText $canonicalMaster @('remote', 'get-url', 'origin')
if ((Normalize-Remote $remote) -ne (Normalize-Remote $officialMasterRemote)) { Stop-Reconciliation 'Master Scaffold update source origin is not the official remote.' }
if (-not [string]::IsNullOrWhiteSpace((Get-GitText $canonicalMaster @('status', '--porcelain')))) { Stop-Reconciliation 'Master Scaffold update source is dirty; restore or pull it before reconciliation.' }

$target = Normalize-Path $TargetPath
$developmentRoot = Join-Path $projectScaffold 'development'
if (-not (Is-Descendant $target $developmentRoot)) { Stop-Reconciliation 'Target Project must be under this Project Scaffold development/ directory.' }
$updaterRoot = (Join-Path $developmentRoot '_framework-updater').TrimEnd('\', '/')
if ($target.Equals($updaterRoot, [StringComparison]::OrdinalIgnoreCase) -or (Is-Descendant $target $updaterRoot)) { Stop-Reconciliation 'The framework updater and all of its descendants are infrastructure, not a Target Project.' }
$targetGitRoot = Get-GitText $target @('rev-parse', '--show-toplevel')
if ([string]::IsNullOrWhiteSpace($targetGitRoot) -or (Normalize-Path $targetGitRoot) -ne $target) { Stop-Reconciliation 'Selected Target Project is not an independent Git repository root.' }

$masterHead = Get-GitText $canonicalMaster @('rev-parse', 'HEAD')
$updaterContractMode = -not [string]::IsNullOrWhiteSpace([string]$marker.updater_contract_version)
if ($updaterContractMode) {
    $installedStatePath = Join-Path $projectScaffold 'artifacts/framework-update/STATE.json'
    if (-not (Test-Path -LiteralPath $installedStatePath -PathType Leaf)) { Stop-Reconciliation 'Updater-contract framework state is missing; run the framework updater recovery flow.' }
    $installedState = Get-Content -Raw -LiteralPath $installedStatePath | ConvertFrom-Json
    $baselineHead = [string]$installedState.installed_head
    if ([string]::IsNullOrWhiteSpace($baselineHead) -or $baselineHead -ne [string]$marker.installed_head) { Stop-Reconciliation 'Updater state and workspace marker disagree; reconciliation is blocked.' }
    if ($baselineHead -ne $masterHead) { Stop-Reconciliation 'A framework update is available. Reconciliation cannot copy it; run a new framework updater dry-run and founder-approved apply first.' }
    $changedPaths = @()
} else {
    $archiveName = [string]$marker.git_archive
    if ([string]::IsNullOrWhiteSpace($archiveName)) { Stop-Reconciliation 'Project Scaffold Git archive is missing from the local marker.' }
    $archivePath = Join-Path $projectScaffold $archiveName
    if (-not (Test-Path -LiteralPath $archivePath -PathType Container)) { Stop-Reconciliation 'Project Scaffold Git archive is unavailable; a safe comparison baseline cannot be established.' }
    $archiveHead = (& git --git-dir=$archivePath rev-parse HEAD 2>$null).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($archiveHead)) { Stop-Reconciliation 'Project Scaffold Git archive has no readable baseline commit.' }
    $baselineHead = if ([string]::IsNullOrWhiteSpace([string]$marker.master_head)) { $archiveHead } else { [string]$marker.master_head }
    & git -C $canonicalMaster merge-base --is-ancestor $baselineHead $masterHead 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-Reconciliation 'Project Scaffold baseline is not an ancestor of the current canonical Master Scaffold.' }
    $changedPaths = @(& git -C $canonicalMaster diff --name-only $baselineHead $masterHead 2>$null | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if ($LASTEXITCODE -ne 0) { Stop-Reconciliation 'Unable to compute canonical Master Scaffold changes.' }
}
$syncPaths = @($changedPaths | Where-Object { Is-SynchronizablePath $_ })
$excludedPaths = @($changedPaths | Where-Object { -not (Is-SynchronizablePath $_) })
$conflicts = New-Object System.Collections.Generic.List[string]
foreach ($relativePath in $syncPaths) {
    $archiveTracked = @(& git --git-dir=$archivePath ls-tree -r --name-only $archiveHead -- $relativePath 2>$null)
    $workspacePath = Join-Path $projectScaffold $relativePath
    if ($archiveTracked.Count -eq 0 -and (Test-Path -LiteralPath $workspacePath)) {
        $conflicts.Add($relativePath)
        continue
    }
    & git --git-dir=$archivePath --work-tree=$projectScaffold diff --quiet $archiveHead -- $relativePath 2>$null
    if ($LASTEXITCODE -ne 0) { $conflicts.Add($relativePath) }
}
if ($conflicts.Count -gt 0) { Stop-Reconciliation ('Project Scaffold local changes conflict with Master Scaffold updates: {0}' -f ($conflicts -join ', ')) }

$appliedPaths = New-Object System.Collections.Generic.List[string]
if (-not $DryRun) {
    foreach ($relativePath in $syncPaths) {
        $sourcePath = Join-Path $canonicalMaster $relativePath
        $destinationPath = Join-Path $projectScaffold $relativePath
        if (Test-Path -LiteralPath $sourcePath -PathType Leaf) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $destinationPath) -Force | Out-Null
            Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Force
        } elseif (Test-Path -LiteralPath $destinationPath) {
            Remove-Item -LiteralPath $destinationPath -Force
        }
        $appliedPaths.Add($relativePath)
    }
    $marker | Add-Member -NotePropertyName master_head -NotePropertyValue $masterHead -Force
    $marker | Add-Member -NotePropertyName reconciliation_status -NotePropertyValue 'safe_root_sync_applied' -Force
    $marker | Add-Member -NotePropertyName last_reconciled_at -NotePropertyValue (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK') -Force
    $marker | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $markerPath -Encoding utf8
}

$freshnessScript = Join-Path $projectScaffold 'scripts/check-scaffold-freshness.ps1'
if (-not (Test-Path -LiteralPath $freshnessScript -PathType Leaf)) { Stop-Reconciliation 'Project Scaffold freshness script is missing after safe root synchronization.' }
$freshness = & powershell -NoProfile -File $freshnessScript -Format json | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { Stop-Reconciliation 'Project Scaffold freshness check failed.' }
$adoptionScript = Join-Path $projectScaffold 'scripts/update-scaffold-project.ps1'
$adoption = & powershell -NoProfile -File $adoptionScript -RepositoryRoot $projectScaffold -TargetPath $target | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { Stop-Reconciliation 'Target Project adoption dry-run failed.' }
if ($adoption.status -ne 'ready_for_opt_in_apply') { Stop-Reconciliation ('Target Project adoption is not ready: {0}' -f $adoption.status) }

[ordered]@{
    status = if ($syncPaths.Count -eq 0) { 'unchanged' } elseif ($DryRun) { 'ready_for_safe_root_sync' } else { 'reconciled' }
    project_scaffold = $projectScaffold
    canonical_master_scaffold = [string]$marker.canonical_master_scaffold
    master_scaffold_update_source = $canonicalMaster
    master_head = $masterHead
    baseline_head = $baselineHead
    target = $target
    root_git_mutation = 'none'
    target_mutation = 'none'
    target_git_mutation = 'none'
    updater_contract_mode = $updaterContractMode
    applied_generic_paths = @($appliedPaths)
    excluded_local_context_paths = @($excludedPaths)
    adoption_dry_run = $adoption
} | ConvertTo-Json -Depth 8
