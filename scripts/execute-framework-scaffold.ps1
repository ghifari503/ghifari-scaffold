param(
  [string]$BackendUnitName,
  [switch]$FrontendOnly,
  [switch]$BackendOnly,
  [switch]$Execute
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

function Replace-OrAppendLine {
  param(
    [string]$Content,
    [string]$Key,
    [string]$Value
  )

  $pattern = "(?m)^- $([regex]::Escape($Key)):\s*.*$"
  $replacement = "- " + $Key + ": " + $Value

  if ([regex]::IsMatch($Content, $pattern)) {
    return [regex]::Replace($Content, $pattern, $replacement)
  }

  return ($Content.TrimEnd() + "`r`n" + $replacement + "`r`n")
}

function Resolve-Commands {
  param(
    [string]$RepoRoot,
    [string]$CurrentPhasePath,
    [string]$FrameworkDecisionPath,
    [string]$BackendUnitName
  )

  $phaseContent = Get-Content $CurrentPhasePath -Raw
  $decisionContent = Get-Content $FrameworkDecisionPath -Raw

  $architectureStyle = Get-LineValue -Content $phaseContent -Key "architecture_style"
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

  $resolvedBackendRoot = $backendRoot
  if (-not [string]::IsNullOrWhiteSpace($BackendUnitName)) {
    $resolvedBackendRoot = "$backendRoot/$BackendUnitName"
  } elseif ($architectureStyle -eq "microservice") {
    Write-Warning "No backend unit name provided. Using the registered backend root as-is."
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
    default { "" }
  }

  $backendCommand = switch ("$backendFramework|$backendRuntime|$packageManager") {
    "nestjs|nodejs|pnpm" { "pnpm dlx @nestjs/cli new $resolvedBackendRoot" }
    "nestjs|nodejs|npm" { "npx @nestjs/cli new $resolvedBackendRoot" }
    "express|nodejs|pnpm" { "mkdir -p $resolvedBackendRoot && cd $resolvedBackendRoot && pnpm init" }
    "fastify|nodejs|pnpm" { "mkdir -p $resolvedBackendRoot && cd $resolvedBackendRoot && pnpm init" }
    "fastapi|python|poetry" { "mkdir -p $resolvedBackendRoot && cd $resolvedBackendRoot && poetry init" }
    "fastapi|python|pip" { "mkdir -p $resolvedBackendRoot && cd $resolvedBackendRoot && python -m venv .venv" }
    "django|python|pip" { "django-admin startproject app $resolvedBackendRoot" }
    "laravel|php|composer" { "composer create-project laravel/laravel $resolvedBackendRoot" }
    default { "" }
  }

  return @{
    developmentRoute = $developmentRoute
    frontendRoot = $frontendRoot
    backendRoot = $resolvedBackendRoot
    frontendCommand = $frontendCommand
    backendCommand = $backendCommand
    stackSignature = "$developmentRoute|$frontendFramework|$frontendRuntime|$backendFramework|$backendRuntime|$packageManager|$primaryDatabase|$databaseAccessLayer"
  }
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$currentPhasePath = Join-Path $repoRoot "docs/CURRENT_PHASE.md"
$frameworkDecisionPath = Join-Path $repoRoot "docs/artifacts/architecture/framework-decision.md"
$planPath = Join-Path $repoRoot "docs/artifacts/architecture/scaffold-execution-plan.md"

$resolved = Resolve-Commands -RepoRoot $repoRoot -CurrentPhasePath $currentPhasePath -FrameworkDecisionPath $frameworkDecisionPath -BackendUnitName $BackendUnitName

$runFrontend = -not $BackendOnly
$runBackend = -not $FrontendOnly

if (-not $resolved.frontendCommand -and $runFrontend) {
  throw "No executable frontend scaffold command mapped for current stack."
}

if (-not $resolved.backendCommand -and $runBackend) {
  throw "No executable backend scaffold command mapped for current stack."
}

$planContent = if (Test-Path $planPath) { Get-Content $planPath -Raw } else { "# Scaffold Execution Plan`r`n" }
$planContent = Replace-OrAppendLine -Content $planContent -Key "execution_mode" -Value ($(if ($Execute) { "executed" } else { "dry_run" }))
$planContent = Replace-OrAppendLine -Content $planContent -Key "resolved_backend_root" -Value $resolved.backendRoot
$planContent = Replace-OrAppendLine -Content $planContent -Key "frontend_execution_selected" -Value ($(if ($runFrontend) { "yes" } else { "no" }))
$planContent = Replace-OrAppendLine -Content $planContent -Key "backend_execution_selected" -Value ($(if ($runBackend) { "yes" } else { "no" }))
$planContent = Replace-OrAppendLine -Content $planContent -Key "stack_signature" -Value $resolved.stackSignature
$planContent = Replace-OrAppendLine -Content $planContent -Key "dry_run_status" -Value "completed"
$planContent = Replace-OrAppendLine -Content $planContent -Key "dry_run_ran_at" -Value (Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz")
$planContent = Replace-OrAppendLine -Content $planContent -Key "dry_run_stack_signature" -Value $resolved.stackSignature
if ($Execute) {
  $planContent = Replace-OrAppendLine -Content $planContent -Key "real_execute_status" -Value "completed"
  $planContent = Replace-OrAppendLine -Content $planContent -Key "real_execute_ran_at" -Value (Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz")
}
Set-Content -Path $planPath -Value $planContent -Encoding UTF8

Write-Host "Scaffold execution mode: $(if ($Execute) { 'EXECUTE' } else { 'DRY RUN' })"
if ($runFrontend) {
  Write-Host "Frontend command: $($resolved.frontendCommand)"
}
if ($runBackend) {
  Write-Host "Backend command : $($resolved.backendCommand)"
}

if (-not $Execute) {
  Write-Host "No commands were executed. Re-run with -Execute to run them."
  exit 0
}

Push-Location $repoRoot
try {
  if ($runFrontend) {
    Invoke-Expression $resolved.frontendCommand
  }
  if ($runBackend) {
    Invoke-Expression $resolved.backendCommand
  }
}
finally {
  Pop-Location
}

Write-Host "Framework scaffold execution finished."
