param(
  [string]$TargetRepo,
  [switch]$UseActiveRoute,
  [switch]$InstallDeps,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Info {
  param([string]$Message)
  Write-Host "[info] $Message"
}

function Resolve-PackageManager {
  param([string]$RepoPath)

  if (Test-Path (Join-Path $RepoPath "pnpm-lock.yaml")) { return "pnpm" }
  if (Test-Path (Join-Path $RepoPath "yarn.lock")) { return "yarn" }
  if (Test-Path (Join-Path $RepoPath "bun.lockb")) { return "bun" }
  return "npm"
}

function Ensure-Directory {
  param([string]$Path)
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

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

function Copy-TemplateFile {
  param(
    [string]$Source,
    [string]$Destination,
    [switch]$Overwrite
  )

  if ((Test-Path $Destination) -and (-not $Overwrite)) {
    Write-Info "Skip existing file: $Destination"
    return
  }

  Copy-Item -Path $Source -Destination $Destination -Force
  Write-Info "Created: $Destination"
}

$frameworkRoot = Split-Path -Parent $PSScriptRoot
$currentPhasePath = Join-Path $frameworkRoot "docs\CURRENT_PHASE.md"

if ($UseActiveRoute) {
  $activeFrontendRoot = Get-ActiveRouteValue -FilePath $currentPhasePath -Key "active_frontend_root"
  if ([string]::IsNullOrWhiteSpace($activeFrontendRoot) -or $activeFrontendRoot -eq "not_selected") {
    throw "Active frontend route not set. Run activate-development-route first."
  }
  $repoPath = Join-Path $frameworkRoot ($activeFrontendRoot -replace '/', '\')
} elseif ($TargetRepo) {
  $repoPath = (Resolve-Path $TargetRepo).Path
} else {
  throw "Provide -TargetRepo or use -UseActiveRoute."
}

$packageJsonPath = Join-Path $repoPath "package.json"
$pkgManager = $null
if (Test-Path $packageJsonPath) {
  $pkgManager = Resolve-PackageManager -RepoPath $repoPath
  Write-Info "Detected package manager: $pkgManager"
} else {
  Write-Info "package.json not found in target path, scaffolding files only."
}

$templatesRoot = Join-Path $frameworkRoot "templates\qa"
$configTemplate = Join-Path $templatesRoot "playwright.config.ts.example"
$testTemplate = Join-Path $templatesRoot "auth-login.functional.spec.ts.example"

$playwrightDir = Join-Path $repoPath "playwright"
$e2eDir = Join-Path $playwrightDir "e2e"
$fixturesDir = Join-Path $playwrightDir "fixtures"
$authDir = Join-Path $playwrightDir ".auth"
$qaArtifactsRoot = Join-Path $repoPath "artifacts\qa\playwright"
$reportDir = Join-Path $qaArtifactsRoot "report"
$resultsDir = Join-Path $qaArtifactsRoot "test-results"
$cliDir = Join-Path $qaArtifactsRoot ".playwright-cli"

Ensure-Directory -Path $playwrightDir
Ensure-Directory -Path $e2eDir
Ensure-Directory -Path $fixturesDir
Ensure-Directory -Path $qaArtifactsRoot
Ensure-Directory -Path $reportDir
Ensure-Directory -Path $resultsDir
Ensure-Directory -Path $cliDir
Ensure-Directory -Path $authDir

Copy-TemplateFile -Source $configTemplate -Destination (Join-Path $repoPath "playwright.config.ts") -Overwrite:$Force
Copy-TemplateFile -Source $testTemplate -Destination (Join-Path $e2eDir "auth-login.functional.spec.ts") -Overwrite:$Force

if (Test-Path $packageJsonPath) {
  $packageJson = Get-Content -Path $packageJsonPath -Raw | ConvertFrom-Json
  if (-not $packageJson.PSObject.Properties["scripts"]) {
    $packageJson | Add-Member -MemberType NoteProperty -Name scripts -Value ([pscustomobject]@{})
  }

  $scriptMap = [ordered]@{
    "test:e2e"        = "playwright test"
    "test:e2e:ui"     = "playwright test --ui"
    "test:e2e:debug"  = "playwright test --debug"
    "test:e2e:headed" = "playwright test --headed"
    "test:e2e:report" = "playwright show-report artifacts/qa/playwright/report"
  }

  foreach ($key in $scriptMap.Keys) {
    $existing = $packageJson.scripts.PSObject.Properties[$key]
    if ($null -eq $existing) {
      $packageJson.scripts | Add-Member -MemberType NoteProperty -Name $key -Value $scriptMap[$key]
      Write-Info "Added package.json script: $key"
    } elseif ($Force) {
      $packageJson.scripts.$key = $scriptMap[$key]
      Write-Info "Updated package.json script: $key"
    } else {
      Write-Info "Keep existing package.json script: $key"
    }
  }

  $packageJson | ConvertTo-Json -Depth 100 | Set-Content -Path $packageJsonPath
}

if ($InstallDeps) {
  if (-not (Test-Path $packageJsonPath)) {
    throw "Cannot install Playwright dependencies because package.json is missing at $repoPath"
  }
  Push-Location $repoPath
  try {
    switch ($pkgManager) {
      "pnpm" {
        & pnpm add -D @playwright/test
        & pnpm exec playwright install
      }
      "yarn" {
        & yarn add -D @playwright/test
        & yarn playwright install
      }
      "bun" {
        & bun add -d @playwright/test
        & bunx playwright install
      }
      default {
        & npm install -D @playwright/test
        & npx playwright install
      }
    }
  } finally {
    Pop-Location
  }
}

Write-Host ""
Write-Host "Playwright scaffold complete."
Write-Host "Target repo       : $repoPath"
Write-Host "Package manager   : $(if ($pkgManager) { $pkgManager } else { 'not_detected' })"
Write-Host "Config            : playwright.config.ts"
Write-Host "Playwright root   : playwright/"
Write-Host "Artifact root     : artifacts/qa/playwright/"
Write-Host "Example test      : playwright/e2e/auth-login.functional.spec.ts"
Write-Host "Report output     : artifacts/qa/playwright/report/"
Write-Host "Run output        : artifacts/qa/playwright/test-results/"
Write-Host "CLI log output    : artifacts/qa/playwright/.playwright-cli/"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Update selectors to match your app (recommended: data-testid)."
Write-Host "2. Start your app locally."
Write-Host "3. Run: npm run test:e2e  (or the equivalent package manager command)"
