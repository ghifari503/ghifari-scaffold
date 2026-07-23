param(
  [switch]$Silent
)

$ErrorActionPreference = "Stop"

function Write-Log {
  param([string]$Message)
  if (-not $Silent) {
    Write-Host $Message
  }
}

& (Join-Path $PSScriptRoot "sync-skills.ps1") -Target "all" -Silent:$Silent

function Get-SkillList {
  param([string]$Runtime)

  $dir = ".$Runtime\skills"
  if (-not (Test-Path $dir)) {
    return @()
  }

  return Get-ChildItem $dir -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notmatch "^\." } |
    ForEach-Object {
      [pscustomobject]@{
        Runtime = $Runtime
        Folder = $_.Name
        Normalized = $_.Name -match "__"
      }
    }
}

function Copy-MissingSkills {
  param(
    [string]$SourceRuntime,
    [string]$TargetRuntime
  )

  $sourceDir = ".$SourceRuntime\skills"
  $targetDir = ".$TargetRuntime\skills"
  $copied = @()

  if (-not (Test-Path $sourceDir) -or -not (Test-Path $targetDir)) {
    return $copied
  }

  $sourceSkills = Get-ChildItem $sourceDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch "^\." }
  foreach ($skill in $sourceSkills) {
    $targetPath = Join-Path $targetDir $skill.Name
    if (-not (Test-Path $targetPath)) {
      Copy-Item -LiteralPath $skill.FullName -Destination $targetPath -Recurse
      $copied += $skill.Name
    }
  }

  return $copied
}

$codex = Get-SkillList -Runtime "codex"
$claude = Get-SkillList -Runtime "claude"
$antigravity = Get-SkillList -Runtime "agents"

$remainingUnprefixed = @($codex + $claude + $antigravity | Where-Object { -not $_.Normalized })
if ($remainingUnprefixed.Count -gt 0) {
  throw "Skill check failed: unprefixed skill folders remain."
}

$copiedToCodex = Copy-MissingSkills -SourceRuntime "claude" -TargetRuntime "codex"
$copiedToClaude = Copy-MissingSkills -SourceRuntime "codex" -TargetRuntime "claude"
$copiedToAntigravity = Copy-MissingSkills -SourceRuntime "codex" -TargetRuntime "agents"

if ($copiedToCodex.Count -gt 0 -or $copiedToClaude.Count -gt 0 -or $copiedToAntigravity.Count -gt 0) {
  & (Join-Path $PSScriptRoot "sync-skills.ps1") -Target "all" -Silent:$Silent
}

$codex = Get-SkillList -Runtime "codex"
$claude = Get-SkillList -Runtime "claude"
$antigravity = Get-SkillList -Runtime "agents"

$codexNames = @($codex | Select-Object -ExpandProperty Folder | Sort-Object -Unique)
$claudeNames = @($claude | Select-Object -ExpandProperty Folder | Sort-Object -Unique)
$shared = @($codexNames | Where-Object { $claudeNames -contains $_ })
$codexOnly = @($codexNames | Where-Object { $claudeNames -notcontains $_ })
$claudeOnly = @($claudeNames | Where-Object { $codexNames -notcontains $_ })
$antigravityNames = @($antigravity | Select-Object -ExpandProperty Folder | Sort-Object -Unique)
$antigravityOnly = @($antigravityNames | Where-Object { $codexNames -notcontains $_ })
$missingAntigravity = @($codexNames | Where-Object { $antigravityNames -notcontains $_ })

if ($codexOnly.Count -gt 0 -or $claudeOnly.Count -gt 0 -or $antigravityOnly.Count -gt 0 -or $missingAntigravity.Count -gt 0) {
  throw "Skill check failed: runtime skill lists are still out of sync."
}

& (Join-Path $PSScriptRoot "check-antigravity-skills.ps1") -Silent:$Silent

Write-Log "Skill check complete."
Write-Log "Catalog refreshed: guardrails/system/SKILL_CATALOG.md"
Write-Log "Codex skill folders : $($codexNames.Count)"
Write-Log "Claude skill folders: $($claudeNames.Count)"
Write-Log "Antigravity folders : $($antigravityNames.Count)"
Write-Log "Shared skills       : $($shared.Count)"
Write-Log "Codex-only skills   : $($codexOnly.Count)"
Write-Log "Claude-only skills  : $($claudeOnly.Count)"
Write-Log "Copied to codex     : $($copiedToCodex.Count)"
Write-Log "Copied to claude    : $($copiedToClaude.Count)"
Write-Log "Copied to antigravity: $($copiedToAntigravity.Count)"

if ($copiedToCodex.Count -gt 0) {
  Write-Log "Added into codex    : $($copiedToCodex -join ', ')"
}

if ($copiedToClaude.Count -gt 0) {
  Write-Log "Added into claude   : $($copiedToClaude -join ', ')"
}
