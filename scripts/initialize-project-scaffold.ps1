[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ProjectScaffoldPath,
    [switch]$CreateTarget
)

$canonicalMaster = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..') -ErrorAction Stop).Path
$projectScaffold = (Resolve-Path -LiteralPath $ProjectScaffoldPath -ErrorAction Stop).Path

if ($projectScaffold.TrimEnd('\') -eq $canonicalMaster.TrimEnd('\')) {
    throw 'Refusing to convert the canonical Master Scaffold into a Project Scaffold.'
}

$developmentPath = Join-Path $projectScaffold 'development'
$targetDetected = $false
if (Test-Path -LiteralPath $developmentPath) {
    $targetDetected = @(
        Get-ChildItem -LiteralPath $developmentPath -Directory -Force | Where-Object {
            $_.Name -ne '_project-template' -and (Test-Path -LiteralPath (Join-Path $_.FullName '.git'))
        }
    ).Count -gt 0
}
if (-not $targetDetected -and -not $CreateTarget) {
    throw 'Project Scaffold conversion requires a nested Target Project or the explicit -CreateTarget switch.'
}

$activeGit = Join-Path $projectScaffold '.git'
$marker = Join-Path $projectScaffold '.project-scaffold.json'
if (-not (Test-Path -LiteralPath $activeGit)) {
    if (-not (Test-Path -LiteralPath $marker)) {
        throw 'No active Project Scaffold .git directory and no local workspace marker were found.'
    }
    [pscustomobject]@{ result = 'already_initialized'; project_scaffold = $projectScaffold; canonical_master = $canonicalMaster } | ConvertTo-Json -Compress
    exit 0
}

$archive = Join-Path $projectScaffold ('.git.project-scaffold-archive-' + (Get-Date -Format 'yyyyMMddHHmmss'))
Move-Item -LiteralPath $activeGit -Destination $archive -ErrorAction Stop
[ordered]@{
    workspace_type = 'project_scaffold'
    canonical_master_scaffold = $canonicalMaster
    git_root_status = 'archived_local_not_a_commit_source'
    git_archive = (Split-Path -Leaf $archive)
    target_project_detected = $targetDetected
} | ConvertTo-Json | Set-Content -LiteralPath $marker -Encoding utf8

[pscustomobject]@{
    result = 'initialized'
    project_scaffold = $projectScaffold
    canonical_master = $canonicalMaster
    git_archive = $archive
    target_project_detected = $targetDetected
} | ConvertTo-Json -Compress
