param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("frontend-page", "backend-unit", "backend-module", "backend-service", "shared-package")]
  [string]$Kind,
  [Parameter(Mandatory = $true)]
  [string]$Name
)

$ErrorActionPreference = "Stop"

function Get-ActiveRouteValue {
  param(
    [string]$FilePath,
    [string]$Key
  )

  $match = Select-String -Path $FilePath -Pattern "^- $Key: `(.*)`$"
  if ($match) {
    return $match.Matches[0].Groups[1].Value
  }
  return $null
}

function Ensure-Directory {
  param([string]$Path)
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$currentPhasePath = Join-Path $repoRoot "docs\CURRENT_PHASE.md"

$frontendRoot = Get-ActiveRouteValue -FilePath $currentPhasePath -Key "active_frontend_root"
$backendRoot = Get-ActiveRouteValue -FilePath $currentPhasePath -Key "active_backend_root"
$sharedContractsRoot = Get-ActiveRouteValue -FilePath $currentPhasePath -Key "active_shared_contracts_root"

switch ($Kind) {
  "frontend-page" {
    if ([string]::IsNullOrWhiteSpace($frontendRoot) -or $frontendRoot -eq "not_selected") {
      throw "Active frontend root not set. Register the route first."
    }
    $target = Join-Path $repoRoot ($frontendRoot -replace '/', '\')
    $target = Join-Path $target $Name
  }
  { $_ -in @("backend-unit", "backend-module", "backend-service") } {
    if ([string]::IsNullOrWhiteSpace($backendRoot) -or $backendRoot -eq "not_selected") {
      throw "Active backend root not set. Register the route first."
    }
    $target = Join-Path $repoRoot ($backendRoot -replace '/', '\')
    $target = Join-Path $target $Name
  }
  "shared-package" {
    if ([string]::IsNullOrWhiteSpace($sharedContractsRoot) -or $sharedContractsRoot -eq "not_selected") {
      throw "Active shared contracts root not set. Register the route first."
    }
    $target = Join-Path $repoRoot ($sharedContractsRoot -replace '/', '\')
    $target = Join-Path $target $Name
  }
}

Ensure-Directory -Path $target
Set-Content -Path (Join-Path $target ".gitkeep") -Value ""

Write-Host "Development unit created."
Write-Host "Kind             : $Kind"
Write-Host "Name             : $Name"
Write-Host "Target path      : $target"
