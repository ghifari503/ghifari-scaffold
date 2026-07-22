param(
  [Parameter(Mandatory = $true)][string]$FrontendFramework,
  [Parameter(Mandatory = $true)][string]$BackendFramework,
  [Parameter(Mandatory = $true)][string]$PrimaryDatabase,
  [Parameter(Mandatory = $true)][string]$PackageManager,
  [Parameter(Mandatory = $true)][string]$TestingStack,
  [string]$FrontendRuntime = "custom",
  [string]$BackendRuntime = "custom",
  [string]$StylingApproach = "other",
  [string]$DatabaseAccessLayer = "other",
  [string]$MigrationTooling = "framework-default",
  [string]$CacheLayer = "none",
  [string]$SearchRequirement = "none"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$currentPhase = Join-Path $repoRoot "docs/CURRENT_PHASE.md"
$workflowState = Join-Path $repoRoot "docs/WORKFLOW_STATE.md"
$frameworkDecision = Join-Path $repoRoot "docs/artifacts/architecture/framework-decision.md"

function Get-LineValue {
  param(
    [string]$Content,
    [string]$Key
  )

  if ($Content -match "(?m)^- $([regex]::Escape($Key)):\s*`?([^`\r\n]+)`?\s*$") {
    return $Matches[1].Trim()
  }

  return ""
}

function Replace-OrAppendLine {
  param(
    [string]$Content,
    [string]$Key,
    [string]$Value
  )

  $pattern = "(?m)^- $([regex]::Escape($Key)):\s*.*$"
  $replacement = "- " + $Key + ": " + '`' + $Value + '`'

  if ([regex]::IsMatch($Content, $pattern)) {
    return [regex]::Replace($Content, $pattern, $replacement)
  }

  return ($Content.TrimEnd() + "`r`n" + $replacement + "`r`n")
}

$phaseContent = Get-Content $currentPhase -Raw
$stateContent = Get-Content $workflowState -Raw

$architectureStyle = Get-LineValue -Content $phaseContent -Key "architecture_style"
$developmentRoute = Get-LineValue -Content $phaseContent -Key "development_route"
$activeFrontendRoot = Get-LineValue -Content $phaseContent -Key "active_frontend_root"
$activeBackendRoot = Get-LineValue -Content $phaseContent -Key "active_backend_root"
$activeSharedContractsRoot = Get-LineValue -Content $phaseContent -Key "active_shared_contracts_root"

if (-not $developmentRoute) {
  throw "development_route is not active yet. Run activate-development-route first."
}

$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "framework_decision_status" -Value "approved"
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "frontend_framework" -Value $FrontendFramework
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "backend_framework" -Value $BackendFramework
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "primary_database" -Value $PrimaryDatabase
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "database_access_layer" -Value $DatabaseAccessLayer
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "package_manager" -Value $PackageManager
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "testing_stack" -Value $TestingStack
$phaseContent = Replace-OrAppendLine -Content $phaseContent -Key "app_bootstrap_allowed" -Value "yes"

$stateContent = Replace-OrAppendLine -Content $stateContent -Key "framework_decision_status" -Value "approved"
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "frontend_framework" -Value $FrontendFramework
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "backend_framework" -Value $BackendFramework
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "primary_database" -Value $PrimaryDatabase
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "database_access_layer" -Value $DatabaseAccessLayer
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "package_manager" -Value $PackageManager
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "testing_stack" -Value $TestingStack
$stateContent = Replace-OrAppendLine -Content $stateContent -Key "app_bootstrap_allowed" -Value "yes"

$now = Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz"
$decisionContent = @"
# Framework Decision

## Metadata
- created_at: $now
- updated_at: $now
- runtime: manual
- status: approved

## Route Context
- architecture_style: $architectureStyle
- development_route: $developmentRoute
- active_frontend_root: $activeFrontendRoot
- active_backend_root: $activeBackendRoot
- active_shared_contracts_root: $activeSharedContractsRoot

## Frontend Stack
- frontend_framework: $FrontendFramework
- frontend_runtime: $FrontendRuntime
- styling_approach: $StylingApproach

## Backend Stack
- backend_framework: $BackendFramework
- backend_runtime: $BackendRuntime

## Data Layer
- primary_database: $PrimaryDatabase
- database_access_layer: $DatabaseAccessLayer
- migration_tooling: $MigrationTooling
- cache_layer: $CacheLayer
- search_requirement: $SearchRequirement

## Tooling
- package_manager: $PackageManager
- testing_stack: $TestingStack

## Scaffold Permission
- app_bootstrap_allowed: yes
- bootstrap_blocker: approved
"@

Set-Content -Path $currentPhase -Value $phaseContent -Encoding UTF8
Set-Content -Path $workflowState -Value $stateContent -Encoding UTF8
Set-Content -Path $frameworkDecision -Value $decisionContent -Encoding UTF8

Write-Host "Framework decision activated."
Write-Host "Frontend framework: $FrontendFramework"
Write-Host "Backend framework: $BackendFramework"
Write-Host "Primary database: $PrimaryDatabase"
Write-Host "Package manager: $PackageManager"
Write-Host "Testing stack: $TestingStack"
