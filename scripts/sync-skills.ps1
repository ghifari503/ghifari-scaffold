param(
  [ValidateSet("auto", "claude", "codex", "all")]
  [string]$Target = "auto",
  [switch]$Silent
)

$ErrorActionPreference = "Stop"

$catalogFile = ".\guardrails\system\SKILL_CATALOG.md"
$runtimeDirs = [ordered]@{
  codex = ".\.codex\skills"
  claude = ".\.claude\skills"
}
$categories = [ordered]@{
  planning = "Planning Phase"
  design   = "Design Phase"
  backend  = "Backend Phase"
  frontend = "Frontend Phase"
  iot      = "IoT Phase"
  qa       = "QA & Review Phase"
  release  = "Release Phase"
  system   = "System & Meta"
}
$explicitSkillCategories = @{
  "better-auth-security-best-practices" = "qa"
  "find-skills" = "system"
  "handoff" = "system"
  "improve-codebase-architecture" = "planning"
  "laravel-specialist" = "backend"
  "security-review" = "qa"
  "vue" = "frontend"
  "vue-best-practices" = "frontend"
  "web-design-guidelines" = "design"
}
$extraEntries = @(
  [ordered]@{
    Category = "frontend"
    Name = "flutter-builder"
    CodexPath = ".codex/agents/flutter-builder.md"
    ClaudePath = ".claude/agents/flutter-builder.md"
    Description = "Flutter/Dart implementation agent for existing projects after intake, impact scan, approved scope, allowed write paths, and open pre-coding gate."
  },
  [ordered]@{
    Category = "frontend"
    Name = "flutter-qa"
    CodexPath = ".codex/agents/flutter-qa.md"
    ClaudePath = ".claude/agents/flutter-qa.md"
    Description = "Flutter/Dart QA agent for analyzer, unit tests, widget tests, integration tests, platform smoke checks, and evidence capture."
  }
)

function Write-Log {
  param([string]$Message)
  if (-not $Silent) {
    Write-Host "[ok] $Message"
  }
}

function Resolve-SelectedRuntimeDirs {
  param([string]$SelectedTarget)

  $selected = [ordered]@{}

  switch ($SelectedTarget) {
    "codex" {
      if (Test-Path $runtimeDirs.codex) { $selected.codex = $runtimeDirs.codex }
    }
    "claude" {
      if (Test-Path $runtimeDirs.claude) { $selected.claude = $runtimeDirs.claude }
    }
    "all" {
      foreach ($runtime in $runtimeDirs.Keys) {
        if (Test-Path $runtimeDirs[$runtime]) {
          $selected[$runtime] = $runtimeDirs[$runtime]
        }
      }
    }
    "auto" {
      if (Test-Path $runtimeDirs.codex) {
        $selected.codex = $runtimeDirs.codex
      }
      elseif (Test-Path $runtimeDirs.claude) {
        $selected.claude = $runtimeDirs.claude
      }
    }
  }

  return $selected
}

function Get-Category {
  param([string]$SkillPath)

  $skillName = Split-Path -Leaf $SkillPath
  if ($explicitSkillCategories.ContainsKey($skillName)) {
    return $explicitSkillCategories[$skillName]
  }

  $skillMd = Join-Path $SkillPath "SKILL.md"
  if (-not (Test-Path $skillMd)) {
    return "system"
  }

  $content = (Get-Content $skillMd -TotalCount 50 | Out-String).ToLowerInvariant()

  if ($content -match "review|qa|test|quality|runner|playwright|cypress") { return "qa" }
  if ($content -match "backend|api|database|schema|endpoint|builder") { return "backend" }
  if ($content -match "frontend|component|page|react|vue|builder") { return "frontend" }
  if ($content -match "release|deploy|checklist|prep") { return "release" }
  if ($content -match "iot|device|firmware|sensor|sync|builder") { return "iot" }
  if ($content -match "interview|requirement|flow|architect|sprint") { return "planning" }
  if ($content -match "design|layout|wireframe|complete") { return "design" }
  return "system"
}

function Get-SkillDescription {
  param([string]$SkillDir)

  $skillMd = Join-Path $SkillDir "SKILL.md"
  if (-not (Test-Path $skillMd)) {
    return $null
  }

  $description = Select-String -Path $skillMd -Pattern "^description:" -SimpleMatch:$false | Select-Object -First 1
  if ($description) {
    return ($description.Line -replace "^description:\s*", "").Trim()
  }

  $title = Select-String -Path $skillMd -Pattern "^# " -SimpleMatch:$false | Select-Object -First 1
  if ($title) {
    return ($title.Line -replace "^#\s*", "").Trim()
  }

  return $null
}

function Get-RelativeSkillDirPath {
  param(
    [string]$Runtime,
    [string]$FolderName
  )

  return ".$Runtime/skills/$FolderName/"
}

function Normalize-SkillFolders {
  param(
    [string]$Runtime,
    [string]$SkillsDir
  )

  $renamed = 0
  $unregistered = Get-ChildItem $SkillsDir -Directory -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -notmatch "__" -and $_.Name -notmatch "^\."
  }

  foreach ($folder in $unregistered) {
    $category = Get-Category -SkillPath $folder.FullName
    $newName = "${category}__$($folder.Name)"
    Rename-Item -LiteralPath $folder.FullName -NewName $newName
    Write-Log "$Runtime registered: $($folder.Name) -> $newName"
    $renamed++
  }

  return $renamed
}

function Add-OrUpdateRecord {
  param(
    [hashtable]$Records,
    [string]$Category,
    [string]$Name,
    [string]$Runtime,
    [string]$Path,
    [string]$Description,
    [string]$Status
  )

  if (-not $categories.Contains($Category)) {
    $Category = "system"
  }

  $key = "$Category|$Name"
  if (-not $Records.ContainsKey($key)) {
    $Records[$key] = [ordered]@{
      Category = $Category
      Name = $Name
      CodexPath = $null
      ClaudePath = $null
      Description = $null
      Status = $null
    }
  }

  if ($Runtime -eq "codex") {
    $Records[$key].CodexPath = $Path
  }
  elseif ($Runtime -eq "claude") {
    $Records[$key].ClaudePath = $Path
  }

  if ($Description -and -not $Records[$key].Description) {
    $Records[$key].Description = $Description
  }

  if ($Status -and -not $Records[$key].Status) {
    $Records[$key].Status = $Status
  }
}

$selectedRuntimeDirs = Resolve-SelectedRuntimeDirs -SelectedTarget $Target
if ($selectedRuntimeDirs.Count -eq 0) {
  throw "No skills directory found for target '$Target'."
}

$totalRenamed = 0
foreach ($runtime in $selectedRuntimeDirs.Keys) {
  $totalRenamed += Normalize-SkillFolders -Runtime $runtime -SkillsDir $selectedRuntimeDirs[$runtime]
}

$records = @{}

foreach ($runtime in $selectedRuntimeDirs.Keys) {
  $skillsDir = $selectedRuntimeDirs[$runtime]
  $skillDirs = Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch "^\." } | Sort-Object Name

  foreach ($dir in $skillDirs) {
    if ($dir.Name -notmatch "__") {
      continue
    }

    $parts = $dir.Name -split "__", 2
    if ($parts.Count -lt 2) {
      continue
    }

    $category = $parts[0]
    $name = $parts[1]
    $description = Get-SkillDescription -SkillDir $dir.FullName
    $status = $null
    if (-not (Test-Path (Join-Path $dir.FullName "SKILL.md"))) {
      $status = "Placeholder (no SKILL.md yet)"
    }

    Add-OrUpdateRecord -Records $records -Category $category -Name $name -Runtime $runtime -Path (Get-RelativeSkillDirPath -Runtime $runtime -FolderName $dir.Name) -Description $description -Status $status
  }
}

foreach ($entry in $extraEntries) {
  $codexExists = Test-Path $entry.CodexPath
  $claudeExists = Test-Path $entry.ClaudePath

  if (-not $codexExists -and -not $claudeExists) {
    continue
  }

  if ($codexExists) {
    Add-OrUpdateRecord -Records $records -Category $entry.Category -Name $entry.Name -Runtime "codex" -Path $entry.CodexPath -Description $entry.Description -Status $null
  }
  if ($claudeExists) {
    Add-OrUpdateRecord -Records $records -Category $entry.Category -Name $entry.Name -Runtime "claude" -Path $entry.ClaudePath -Description $entry.Description -Status $null
  }
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Skill Catalog")
$lines.Add("")
$lines.Add("Comprehensive index of all available skills, organized by workflow phase.")
$lines.Add("")
$lines.Add("---")
$lines.Add("")
$lines.Add("## Index")
$lines.Add("")
$lines.Add("> Compatibility note: this catalog is regenerated from the runtime skill folders and records availability across `.codex` and `.claude`.")
$lines.Add("")

foreach ($key in $categories.Keys) {
  $items = $records.Values | Where-Object { $_.Category -eq $key } | Sort-Object Name
  if (-not $items) { continue }

  $lines.Add("### $($categories[$key])")
  foreach ($item in $items) {
    $lines.Add("- [$($item.Name)](#$key-$($item.Name))")
  }
  $lines.Add("")
}

$lines.Add("---")
$lines.Add("")

foreach ($key in $categories.Keys) {
  $items = $records.Values | Where-Object { $_.Category -eq $key } | Sort-Object Name
  if (-not $items) { continue }

  $lines.Add("## $($categories[$key])")
  $lines.Add("")

  foreach ($item in $items) {
    $lines.Add("### ${key}_$($item.Name)")

    $availability = @()
    if ($item.CodexPath) { $availability += "codex" }
    if ($item.ClaudePath) { $availability += "claude" }
    $lines.Add("**Availability:** $($availability -join ', ')")

    if ($item.CodexPath) {
      $lines.Add("**Codex Path:** ``$($item.CodexPath)``")
    }
    if ($item.ClaudePath) {
      $lines.Add("**Claude Path:** ``$($item.ClaudePath)``")
    }
    if ($item.Description) {
      $lines.Add("**Description:** $($item.Description)")
    }
    elseif ($item.Status) {
      $lines.Add("**Status:** $($item.Status)")
    }
    if (-not $item.CodexPath -or -not $item.ClaudePath) {
      $missingRuntime = if (-not $item.CodexPath) { "codex" } else { "claude" }
      $lines.Add("**Parity Note:** Missing in $missingRuntime runtime.")
    }

    $lines.Add("")
  }
}

$lines.Add("---")
$lines.Add("")
$lines.Add("**Generated by:** ``scripts/sync-skills.ps1 -Target $Target``")

Set-Content -Path $catalogFile -Value $lines
Write-Log "SKILL_CATALOG.md regenerated at $catalogFile"

if ($totalRenamed -gt 0) {
  Write-Log "Summary: $totalRenamed skill folder(s) normalized"
}
else {
  Write-Log "Summary: no new unprefixed skill folders found"
}
