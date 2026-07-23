param(
  [switch]$Silent
)

$ErrorActionPreference = "Stop"

$config = Get-Content -Raw ".claude/model-routing.json" | ConvertFrom-Json
if ($config.runtime -ne "claude-code-vscode" -or $config.defaultModel -ne "sonnet") {
  throw "Claude routing config has an invalid runtime or default model."
}

$expected = @{ L0 = "haiku"; L1 = "sonnet"; L2 = "sonnet"; L3 = "opus"; L4 = "configured_fable_only" }
foreach ($level in $expected.Keys) {
  if ($config.profiles.$level.model -ne $expected[$level]) {
    throw "Claude routing config has an invalid model for $level."
  }
}

foreach ($agent in @("claude-routing-supervisor.md", "claude-fast-worker.md", "claude-deep-reviewer.md")) {
  if (-not (Test-Path ".claude/agents/$agent")) {
    throw "Missing Claude routing agent: $agent"
  }
}

$settings = Get-Content -Raw ".claude/settings.json" | ConvertFrom-Json
if ($settings.model -ne "sonnet") {
  throw "Claude project settings must default new sessions to Sonnet."
}

if (-not $Silent) {
  Write-Host "Claude Code VS Code routing validation passed."
}
