param()

$ErrorActionPreference = "Stop"

$root = (git rev-parse --show-toplevel).Trim()
if (-not $root) {
  throw "Run this script from inside the scaffold Git repository."
}

$hooksPath = Join-Path $root ".githooks"
if (-not (Test-Path (Join-Path $hooksPath "pre-commit")) -or -not (Test-Path (Join-Path $hooksPath "pre-push"))) {
  throw "Scaffold protection hooks are missing from $hooksPath."
}

git config core.hooksPath .githooks
Write-Host "Scaffold Git protection enabled. Commit and push project work from development/[project-folder]."
