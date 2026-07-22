param(
  [string]$BackendUnitName,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

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

function Ensure-Directory {
  param([string]$Path)
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$currentPhasePath = Join-Path $repoRoot "docs/CURRENT_PHASE.md"
$frameworkDecisionPath = Join-Path $repoRoot "docs/artifacts/architecture/framework-decision.md"

$phaseContent = Get-Content $currentPhasePath -Raw
$decisionContent = Get-Content $frameworkDecisionPath -Raw

$architectureStyle = Get-LineValue -Content $phaseContent -Key "architecture_style"
$backendRoot = Get-LineValue -Content $phaseContent -Key "active_backend_root"
$databaseAccessLayer = Get-LineValue -Content $decisionContent -Key "database_access_layer"

if (-not $databaseAccessLayer) {
  throw "database_access_layer has not been selected in the framework decision."
}

$resolvedBackendRoot = Join-Path $repoRoot ($backendRoot -replace '/', '\')
if (-not [string]::IsNullOrWhiteSpace($BackendUnitName)) {
  $resolvedBackendRoot = Join-Path $resolvedBackendRoot $BackendUnitName
} elseif ($architectureStyle -eq "microservice") {
  Write-Warning "No backend unit name provided. Using the registered backend root as-is."
}

switch ($databaseAccessLayer) {
  "prisma" {
    $source = Join-Path $repoRoot "templates\database\prisma\schema.prisma.example"
    $target = Join-Path $resolvedBackendRoot "prisma\schema.prisma"
  }
  "drizzle" {
    $source = Join-Path $repoRoot "templates\database\drizzle\schema.ts.example"
    $target = Join-Path $resolvedBackendRoot "src\db\schema.ts"
  }
  "sqlalchemy" {
    $source = Join-Path $repoRoot "templates\database\sqlalchemy\models.py.example"
    $target = Join-Path $resolvedBackendRoot "app\models.py"
  }
  "django-orm" {
    $source = Join-Path $repoRoot "templates\database\django\models.py.example"
    $target = Join-Path $resolvedBackendRoot "app\models.py"
  }
  "eloquent" {
    $source = Join-Path $repoRoot "templates\database\laravel\0001_create_example_table.php.example"
    $target = Join-Path $resolvedBackendRoot "database\migrations\0001_create_example_table.php"
  }
  "mongoose" {
    $source = Join-Path $repoRoot "templates\database\mongoose\example.model.ts"
    $target = Join-Path $resolvedBackendRoot "src\models\example.model.ts"
  }
  default {
    throw "No starter template configured for database_access_layer: $databaseAccessLayer"
  }
}

$targetDir = Split-Path -Parent $target
Ensure-Directory -Path $resolvedBackendRoot
Ensure-Directory -Path $targetDir

if ((Test-Path $target) -and (-not $Force)) {
  throw "Target already exists: $target. Use -Force to overwrite."
}

Copy-Item -Path $source -Destination $target -Force

Write-Host "Database starter applied."
Write-Host "Access layer: $databaseAccessLayer"
Write-Host "Target path  : $target"
