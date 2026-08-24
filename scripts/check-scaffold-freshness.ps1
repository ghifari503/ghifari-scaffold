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

function Get-Version([string]$Root) {
    $path = Join-Path $Root 'SCAFFOLD_VERSION.md'
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
    $match = [regex]::Match((Get-Content -Raw -LiteralPath $path), '(?m)^-\s*version:\s*`?([^`\r\n]+)`?\s*$')
    if (-not $match.Success) { return $null }
    return $match.Groups[1].Value.Trim().Trim('`')
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
$installedVersion = Get-Version $repositoryRoot
$updaterRoot = Join-Path $repositoryRoot 'development/_framework-updater'
$updaterStatus = 'not_installed'
$availableVersion = $null
$pendingFrameworkUpdate = $false
if (Test-Path -LiteralPath (Join-Path $updaterRoot '.git')) {
    $availableVersion = Get-Version $updaterRoot
    if ((Test-Path -LiteralPath (Join-Path $updaterRoot '.git') -PathType Leaf) -or [string]::IsNullOrWhiteSpace($availableVersion)) {
        $updaterStatus = 'invalid_updater'
        $pendingFrameworkUpdate = $true
    } else {
        $statePath = Join-Path $repositoryRoot 'artifacts/framework-update/STATE.json'
        $installedHead = $null
        $statePresent = Test-Path -LiteralPath $statePath -PathType Leaf
        if ($statePresent) {
            try {
                $installedHead = [string](Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json).installed_head
                if ([string]::IsNullOrWhiteSpace($installedHead)) { $updaterStatus = 'invalid_local_state' }
            } catch { $updaterStatus = 'invalid_local_state' }
        }
        $updaterHeadOutput = & git -C $updaterRoot rev-parse HEAD 2>$null
        $updaterHead = if ($LASTEXITCODE -eq 0 -and $null -ne $updaterHeadOutput) { ($updaterHeadOutput -join '').Trim() } else { '' }
        if ([string]::IsNullOrWhiteSpace($updaterHead)) { $updaterStatus = 'invalid_updater'; $pendingFrameworkUpdate = $true }
        if ($updaterStatus -eq 'invalid_local_state') {
            $pendingFrameworkUpdate = $true
        } elseif ($updaterStatus -eq 'invalid_updater') {
            $pendingFrameworkUpdate = $true
        } else {
            $pendingFrameworkUpdate = -not $statePresent -or [string]::IsNullOrWhiteSpace($installedVersion) -or $availableVersion -ne $installedVersion -or $updaterHead -ne $installedHead
            $updaterStatus = if ($pendingFrameworkUpdate) { 'update_available' } else { 'current' }
        }
    }
}
$result = [ordered]@{
    repository_root = $repositoryRoot
    git_head = $gitHead
    fingerprint = Get-TextHash $fingerprintInput
    sources = $hashes
    network_action = 'none'
    installed_version = $(if ([string]::IsNullOrWhiteSpace($installedVersion)) { 'unversioned' } else { $installedVersion })
    available_version = $availableVersion
    framework_updater_status = $updaterStatus
    pending_framework_update = $pendingFrameworkUpdate
}

if ($Format -eq 'json') {
    $result | ConvertTo-Json -Depth 3
} else {
    "SCAFFOLD_FRESHNESS_OK"
    "git_head=$($result.git_head)"
    "fingerprint=$($result.fingerprint)"
    "network_action=none"
    "framework_updater_status=$($result.framework_updater_status)"
    "pending_framework_update=$($result.pending_framework_update)"
    $hashes.GetEnumerator() | ForEach-Object { "source=$($_.Key) hash=$($_.Value)" }
}
