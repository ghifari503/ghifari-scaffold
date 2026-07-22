param(
  [switch]$WriteStarterFiles
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
$outputPlanPath = Join-Path $repoRoot "docs/artifacts/architecture/scaffold-execution-plan.md"

$phaseContent = Get-Content $currentPhasePath -Raw
$decisionContent = Get-Content $frameworkDecisionPath -Raw

$developmentRoute = Get-LineValue -Content $phaseContent -Key "development_route"
$frontendRoot = Get-LineValue -Content $phaseContent -Key "active_frontend_root"
$backendRoot = Get-LineValue -Content $phaseContent -Key "active_backend_root"
$frontendFramework = Get-LineValue -Content $decisionContent -Key "frontend_framework"
$frontendRuntime = Get-LineValue -Content $decisionContent -Key "frontend_runtime"
$backendFramework = Get-LineValue -Content $decisionContent -Key "backend_framework"
$backendRuntime = Get-LineValue -Content $decisionContent -Key "backend_runtime"
$packageManager = Get-LineValue -Content $decisionContent -Key "package_manager"
$primaryDatabase = Get-LineValue -Content $decisionContent -Key "primary_database"
$databaseAccessLayer = Get-LineValue -Content $decisionContent -Key "database_access_layer"
$appBootstrapAllowed = Get-LineValue -Content $decisionContent -Key "app_bootstrap_allowed"

if ($appBootstrapAllowed -ne "yes") {
  throw "App bootstrap is not allowed yet. Activate framework decision first."
}

$frontendCommand = switch ("$frontendFramework|$frontendRuntime|$packageManager") {
  "react|vite|pnpm" { "pnpm create vite $frontendRoot --template react-ts" }
  "react|vite|npm" { "npm create vite@latest $frontendRoot -- --template react-ts" }
  "vue|vite|pnpm" { "pnpm create vue@latest $frontendRoot" }
  "vue|vite|npm" { "npm create vue@latest $frontendRoot" }
  "nextjs|next-runtime|pnpm" { "pnpm create next-app $frontendRoot --ts --app" }
  "nextjs|next-runtime|npm" { "npx create-next-app@latest $frontendRoot --ts --app" }
  "nuxt|nuxt-runtime|pnpm" { "pnpm dlx nuxi@latest init $frontendRoot" }
  "nuxt|nuxt-runtime|npm" { "npx nuxi@latest init $frontendRoot" }
  default { "Manual scaffold required for frontend stack: $frontendFramework / $frontendRuntime / $packageManager" }
}

$backendCommand = switch ("$backendFramework|$backendRuntime|$packageManager") {
  "nestjs|nodejs|pnpm" { "pnpm dlx @nestjs/cli new $backendRoot" }
  "nestjs|nodejs|npm" { "npx @nestjs/cli new $backendRoot" }
  "express|nodejs|pnpm" { "mkdir -p $backendRoot && cd $backendRoot && pnpm init" }
  "fastify|nodejs|pnpm" { "mkdir -p $backendRoot && cd $backendRoot && pnpm init" }
  "fastapi|python|poetry" { "mkdir -p $backendRoot && cd $backendRoot && poetry init" }
  "fastapi|python|pip" { "mkdir -p $backendRoot && cd $backendRoot && python -m venv .venv" }
  "django|python|pip" { "django-admin startproject app $backendRoot" }
  "laravel|php|composer" { "composer create-project laravel/laravel $backendRoot" }
  default { "Manual scaffold required for backend stack: $backendFramework / $backendRuntime / $packageManager" }
}

$now = Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz"
$stackSignature = "$developmentRoute|$frontendFramework|$frontendRuntime|$backendFramework|$backendRuntime|$packageManager|$primaryDatabase|$databaseAccessLayer"
$planContent = @"
# Scaffold Execution Plan

## Metadata
- created_at: $now
- updated_at: $now
- status: draft

## Route Context
- development_route: $developmentRoute
- active_frontend_root: $frontendRoot
- active_backend_root: $backendRoot

## Active Stack
- frontend_framework: $frontendFramework
- frontend_runtime: $frontendRuntime
- backend_framework: $backendFramework
- backend_runtime: $backendRuntime
- package_manager: $packageManager
- primary_database: $primaryDatabase
- database_access_layer: $databaseAccessLayer

## Scaffold Status Markers
- stack_signature: $stackSignature
- dry_run_status: not_run
- dry_run_ran_at: not_run
- dry_run_stack_signature: not_run
- real_execute_status: not_run
- real_execute_ran_at: not_run

## Suggested Scaffold Commands
- frontend_command: $frontendCommand
- backend_command: $backendCommand

## Guardrails
- run only inside confirmed active roots
- confirm package manager and toolchain availability first
- pass an explicit backend unit name if the backend root is still a collection root
"@

Set-Content -Path $outputPlanPath -Value $planContent -Encoding UTF8

if ($WriteStarterFiles) {
  $frontendPath = Join-Path $repoRoot ($frontendRoot -replace '/', '\')
  $backendPath = Join-Path $repoRoot ($backendRoot -replace '/', '\')
  Ensure-Directory -Path $frontendPath
  Ensure-Directory -Path $backendPath
  Set-Content -Path (Join-Path $frontendPath "scaffold.todo.md") -Value "# Frontend Scaffold`n`n$frontendCommand" -Encoding UTF8
  Set-Content -Path (Join-Path $backendPath "scaffold.todo.md") -Value "# Backend Scaffold`n`n$backendCommand" -Encoding UTF8
}

Write-Host "Scaffold execution plan prepared: $outputPlanPath"
Write-Host "Frontend command: $frontendCommand"
Write-Host "Backend command : $backendCommand"
