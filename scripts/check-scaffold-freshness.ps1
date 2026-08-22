[CmdletBinding()]
param(
    [ValidateSet('text', 'json')]
    [string]$Format = 'text'
)

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$files = @(
    'AGENTS.md',
    'COMMANDS.md',
    'SCAFFOLD_VERSION.md',
    'artifacts/operations/WORKFLOW_STATE.md',
    'artifacts/operations/CURRENT_PHASE.md',
    'artifacts/operations/CURRENT_TASK.md',
    'artifacts/operations/SESSION_LOG.md'
)

function Get-RequiredHash([string]$RelativePath) {
    $fullPath = Join-Path $repositoryRoot $RelativePath
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        throw "Required scaffold freshness source is missing: $RelativePath"
    }
    return (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Get-TextHash([string]$Value) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    return ([System.BitConverter]::ToString($hash) -replace '-', '').ToLowerInvariant()
}

$activityPath = Join-Path $repositoryRoot 'artifacts/operations/AGENT_ACTIVITY_LOG.md'
if (-not (Test-Path -LiteralPath $activityPath -PathType Leaf)) {
    throw 'Required scaffold freshness source is missing: artifacts/operations/AGENT_ACTIVITY_LOG.md'
}

$hashes = [ordered]@{}
foreach ($relativePath in $files) {
    $hashes[$relativePath] = Get-RequiredHash $relativePath
}
$activitySnapshot = (Get-Content -LiteralPath $activityPath -TotalCount 14) -join "`n"
$hashes['artifacts/operations/AGENT_ACTIVITY_LOG.md#snapshot'] = Get-TextHash $activitySnapshot

$gitHead = 'not_a_git_repository'
try {
    $gitHead = (& git -C $repositoryRoot rev-parse HEAD 2>$null).Trim()
    if ([string]::IsNullOrWhiteSpace($gitHead)) { $gitHead = 'unavailable' }
} catch {
    $gitHead = 'unavailable'
}

$fingerprintInput = "git_head=$gitHead`n" + (($hashes.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "`n")
$result = [ordered]@{
    repository_root = $repositoryRoot
    git_head = $gitHead
    fingerprint = Get-TextHash $fingerprintInput
    sources = $hashes
    network_action = 'none'
}

if ($Format -eq 'json') {
    $result | ConvertTo-Json -Depth 3
} else {
    "SCAFFOLD_FRESHNESS_OK"
    "git_head=$($result.git_head)"
    "fingerprint=$($result.fingerprint)"
    "network_action=none"
    $hashes.GetEnumerator() | ForEach-Object { "source=$($_.Key) hash=$($_.Value)" }
}
