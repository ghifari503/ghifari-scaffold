param([switch]$Silent)

$ErrorActionPreference = "Stop"
$canonicalRoot = Join-Path $PSScriptRoot "..\.codex\skills"
$antigravityRoot = Join-Path $PSScriptRoot "..\.agents\skills"

function Get-RelativeHashes {
  param([string]$Root)
  $rootPath = (Resolve-Path $Root).Path
  $prefix = "$rootPath$([IO.Path]::DirectorySeparatorChar)"
  $hashes = @{}
  Get-ChildItem -LiteralPath $rootPath -File -Recurse | ForEach-Object {
    $relative = $_.FullName.Substring($prefix.Length).Replace('\', '/')
    $hashes[$relative] = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
  }
  return $hashes
}

if (-not (Test-Path $canonicalRoot) -or -not (Test-Path $antigravityRoot)) {
  throw "Codex or Antigravity skill root is missing."
}

$canonical = Get-RelativeHashes -Root $canonicalRoot
$antigravity = Get-RelativeHashes -Root $antigravityRoot
if ($canonical.Count -ne $antigravity.Count) { throw "Antigravity skill mirror file count differs from Codex." }
foreach ($path in $canonical.Keys) {
  if (-not $antigravity.ContainsKey($path) -or $canonical[$path] -ne $antigravity[$path]) {
    throw "Antigravity skill mirror differs: $path"
  }
}
if (-not $Silent) { Write-Host "[ok] Antigravity skill mirror matches Codex." }
