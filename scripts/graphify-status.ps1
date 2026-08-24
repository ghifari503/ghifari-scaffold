[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$ProjectPath
)

$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath -ErrorAction Stop).Path
$scaffoldRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ($resolvedProject.TrimEnd('\') -eq $scaffoldRoot.TrimEnd('\')) {
    throw 'Graphify must run in a selected target project, not in the master scaffold root.'
}
$updaterRoot = (Join-Path $scaffoldRoot 'development/_framework-updater').TrimEnd('\', '/')
$updaterPrefix = $updaterRoot + [IO.Path]::DirectorySeparatorChar
if ($resolvedProject.TrimEnd('\', '/').Equals($updaterRoot, [StringComparison]::OrdinalIgnoreCase) -or $resolvedProject.StartsWith($updaterPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'The framework updater and all of its descendants are infrastructure and must never be a Graphify target.'
}

$outputPath = Join-Path $resolvedProject 'graphify-out'
$graphPath = Join-Path $outputPath 'graph.json'
$reportPath = Join-Path $outputPath 'GRAPH_REPORT.md'
$graphifyCommand = Get-Command graphify -ErrorAction SilentlyContinue
$graphifyVersion = $null
if ($graphifyCommand) {
    try { $graphifyVersion = (graphify --version | Select-Object -First 1).Trim() } catch { $graphifyVersion = 'installed_version_unavailable' }
}

$hasRelevantWorkingChange = $false
if (Test-Path -LiteralPath (Join-Path $resolvedProject '.git')) {
    try {
        $workingChanges = @(git -C $resolvedProject status --porcelain --untracked-files=all 2>$null)
        $hasRelevantWorkingChange = @($workingChanges | Where-Object {
            $_ -notmatch '(^|\s)graphify-out([/\\]|$)' -and $_ -notmatch '(^|\s)\.graphify-state\.json$'
        }).Count -gt 0
    } catch { }
}

$status = if (-not (Test-Path -LiteralPath $graphPath)) {
    'missing'
} elseif (-not (Test-Path -LiteralPath (Join-Path $resolvedProject '.git'))) {
    'present_unverified'
} else {
    $graphTime = (Get-Item -LiteralPath $graphPath).LastWriteTimeUtc
    $headTime = [DateTime]::MinValue
    try {
        $headTime = [DateTime]::Parse((git -C $resolvedProject log -1 --format=%cI)).ToUniversalTime()
    } catch { }
    if ($headTime -gt $graphTime -or $hasRelevantWorkingChange) { 'stale' } else { 'current' }
}

[pscustomobject]@{
    project_path = $resolvedProject
    status = $status
    graphify_installed = [bool]$graphifyCommand
    graphify_version = $graphifyVersion
    graph_path = if (Test-Path -LiteralPath $graphPath) { $graphPath } else { $null }
    report_path = if (Test-Path -LiteralPath $reportPath) { $reportPath } else { $null }
    relevant_working_changes_detected = $hasRelevantWorkingChange
    action_required = $status -in @('missing', 'stale', 'present_unverified')
} | ConvertTo-Json -Compress
