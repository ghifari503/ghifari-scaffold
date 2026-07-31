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

$outputPath = Join-Path $resolvedProject 'graphify-out'
$graphPath = Join-Path $outputPath 'graph.json'
$reportPath = Join-Path $outputPath 'GRAPH_REPORT.md'
$graphifyCommand = Get-Command graphify -ErrorAction SilentlyContinue
$graphifyVersion = $null
if ($graphifyCommand) {
    try { $graphifyVersion = (graphify --version | Select-Object -First 1).Trim() } catch { $graphifyVersion = 'installed_version_unavailable' }
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
    if ($headTime -gt $graphTime) { 'stale' } else { 'current' }
}

[pscustomobject]@{
    project_path = $resolvedProject
    status = $status
    graphify_installed = [bool]$graphifyCommand
    graphify_version = $graphifyVersion
    graph_path = if (Test-Path -LiteralPath $graphPath) { $graphPath } else { $null }
    report_path = if (Test-Path -LiteralPath $reportPath) { $reportPath } else { $null }
    action_required = $status -in @('missing', 'stale', 'present_unverified')
} | ConvertTo-Json -Compress
