[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [switch]$RequireClosure
)

$ErrorActionPreference = 'Stop'

function Get-MetadataValue {
    param([string]$Content, [string]$Name)
    $match = [regex]::Match($Content, "(?m)^-\s+$([regex]::Escape($Name)):\s*`?([^`\r\n]+)`?\s*$")
    if ($match.Success) { return $match.Groups[1].Value.Trim().Trim('`') }
    return $null
}

function Fail([string]$Message) {
    Write-Error "DOCUMENTATION_SYNC_INVALID: $Message"
    exit 1
}

$taskPath = Join-Path $RepositoryRoot 'artifacts/operations/CURRENT_TASK.md'
$workflowPath = Join-Path $RepositoryRoot 'artifacts/operations/WORKFLOW_STATE.md'
$sessionPath = Join-Path $RepositoryRoot 'artifacts/operations/SESSION_LOG.md'
$activityPath = Join-Path $RepositoryRoot 'artifacts/operations/AGENT_ACTIVITY_LOG.md'

foreach ($path in @($taskPath, $workflowPath, $sessionPath, $activityPath)) {
    if (-not (Test-Path -LiteralPath $path)) { Fail "Required operational artifact is missing: $path" }
}

$task = Get-Content -Raw -LiteralPath $taskPath
$taskId = Get-MetadataValue $task 'task_id'
$taskSize = Get-MetadataValue $task 'task_size'
$taskStatus = Get-MetadataValue $task 'current_status'
$planPath = Get-MetadataValue $task 'approved_plan'
$checklistPath = Get-MetadataValue $task 'approval_checklist'
$qaRequired = Get-MetadataValue $task 'qa_evidence_required'
$qaPath = Get-MetadataValue $task 'qa_evidence_path'

if ([string]::IsNullOrWhiteSpace($taskId)) { Fail 'CURRENT_TASK.md has no task_id.' }
if ($taskSize -notin @('medium', 'major')) {
    Write-Output "DOCUMENTATION_SYNC_OK: $taskId is not a strict medium/major closure task."
    exit 0
}

$closureStatus = $taskStatus -match '(?i)(SUCCESS|COMPLETED|VERIFIED|CLOSED|READY_TO_PR|READY_TO_COMMIT)'
if (-not $closureStatus -and -not $RequireClosure) {
    Write-Output "DOCUMENTATION_SYNC_OK: $taskId has no closure claim yet ($taskStatus)."
    exit 0
}
if (-not $closureStatus) { Fail "Task $taskId is not in a documented closure status. Current status: $taskStatus" }

if ([string]::IsNullOrWhiteSpace($planPath) -or -not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $planPath))) {
    Fail "Approved plan is missing or unreadable for $taskId."
}
if ([string]::IsNullOrWhiteSpace($checklistPath) -or -not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $checklistPath))) {
    Fail "Approved plan checklist is missing or unreadable for $taskId."
}

$workflow = Get-Content -Raw -LiteralPath $workflowPath
if ($workflow -notmatch [regex]::Escape($taskId)) { Fail "WORKFLOW_STATE.md does not reference $taskId." }

$session = Get-Content -Raw -LiteralPath $sessionPath
$sessionPattern = '(?s)## Session:.*?- active_task_id:\s*`' + [regex]::Escape($taskId) + '`.*?- documentation_sync_status:\s*`(completed|no additional documentation delta required)`'
if ($session -notmatch $sessionPattern) { Fail "SESSION_LOG.md has no completed documentation-sync entry for $taskId." }

$activity = Get-Content -Raw -LiteralPath $activityPath
if ($activity -notmatch [regex]::Escape($taskId)) { Fail "AGENT_ACTIVITY_LOG.md has no meaningful-work event for $taskId." }

if ($qaRequired -eq 'yes') {
    if ([string]::IsNullOrWhiteSpace($qaPath) -or -not (Test-Path -LiteralPath (Join-Path $RepositoryRoot $qaPath))) {
        Fail "QA evidence is required but qa_evidence_path is missing or unreadable for $taskId."
    }
}

Write-Output "DOCUMENTATION_SYNC_OK: $taskId closure evidence is complete."
