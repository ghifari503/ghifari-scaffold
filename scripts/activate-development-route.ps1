param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("monolith_modular", "microservice", "custom")]
  [string]$ArchitectureStyle,
  [Parameter(Mandatory = $true)]
  [string]$DevelopmentRoute,
  [Parameter(Mandatory = $true)]
  [string]$FrontendRoot,
  [Parameter(Mandatory = $true)]
  [string]$BackendRoot,
  [Parameter(Mandatory = $true)]
  [string]$SharedContractsRoot
)

$ErrorActionPreference = "Stop"

function Update-LineValue {
  param(
    [string]$Content,
    [string]$Pattern,
    [string]$Replacement
  )

  return [regex]::Replace($Content, $Pattern, $Replacement, [System.Text.RegularExpressions.RegexOptions]::Multiline)
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$currentPhasePath = Join-Path $repoRoot "docs\CURRENT_PHASE.md"
$workflowStatePath = Join-Path $repoRoot "docs\WORKFLOW_STATE.md"
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"

$currentPhase = Get-Content -Path $currentPhasePath -Raw
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- architecture_style: `.*`$' -Replacement "- architecture_style: ``$ArchitectureStyle``"
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- development_route: `.*`$' -Replacement "- development_route: ``$DevelopmentRoute``"
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- active_frontend_root: `.*`$' -Replacement "- active_frontend_root: ``$FrontendRoot``"
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- active_backend_root: `.*`$' -Replacement "- active_backend_root: ``$BackendRoot``"
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- active_shared_contracts_root: `.*`$' -Replacement "- active_shared_contracts_root: ``$SharedContractsRoot``"
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- current_routes_audited: `.*`$' -Replacement "- current_routes_audited: ``yes``"
$currentPhase = Update-LineValue -Content $currentPhase -Pattern '^- updated_at: `.*`$' -Replacement "- updated_at: ``$timestamp``"
Set-Content -Path $currentPhasePath -Value $currentPhase

$workflowState = Get-Content -Path $workflowStatePath -Raw
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- architecture_style: `.*`$' -Replacement "- architecture_style: ``$ArchitectureStyle``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- development_route: `.*`$' -Replacement "- development_route: ``$DevelopmentRoute``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- active_frontend_root: `.*`$' -Replacement "- active_frontend_root: ``$FrontendRoot``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- active_backend_root: `.*`$' -Replacement "- active_backend_root: ``$BackendRoot``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- active_shared_contracts_root: `.*`$' -Replacement "- active_shared_contracts_root: ``$SharedContractsRoot``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- current_routes_audited: `.*`$' -Replacement "- current_routes_audited: ``yes``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- active_route_status: `.*`$' -Replacement "- active_route_status: ``confirmed``"
$workflowState = Update-LineValue -Content $workflowState -Pattern '^- Last Updated: `.*`$' -Replacement "- Last Updated: ``$timestamp``"
Set-Content -Path $workflowStatePath -Value $workflowState

Write-Host "Development route registered."
Write-Host "Architecture style : $ArchitectureStyle"
Write-Host "Development route  : $DevelopmentRoute"
Write-Host "Frontend root      : $FrontendRoot"
Write-Host "Backend root       : $BackendRoot"
Write-Host "Shared contracts   : $SharedContractsRoot"
