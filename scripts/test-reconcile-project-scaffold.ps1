[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$reconcileScript = Join-Path $PSScriptRoot 'reconcile-project-scaffold.ps1'
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('project-scaffold-reconcile-' + [guid]::NewGuid().ToString('N'))

function Invoke-Git([string]$Path, [string[]]$Arguments) {
    & git -C $Path @Arguments
    if ($LASTEXITCODE -ne 0) { throw "Git failed: $($Arguments -join ' ')" }
}

try {
    $canonical = Join-Path $fixtureRoot 'master'
    $projectScaffold = Join-Path $fixtureRoot 'project-scaffold'
    $target = Join-Path $projectScaffold 'development/demo'
    New-Item -ItemType Directory -Path $canonical -Force | Out-Null
    Invoke-Git $canonical @('init')
    Invoke-Git $canonical @('config', 'user.email', 'fixture@example.test')
    Invoke-Git $canonical @('config', 'user.name', 'Fixture')
    @('scripts', 'artifacts/traceability', 'artifacts/operations') | ForEach-Object { New-Item -ItemType Directory -Path (Join-Path $canonical $_) -Force | Out-Null }
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'scripts/update-scaffold-project.ps1') -Destination (Join-Path $canonical 'scripts/update-scaffold-project.ps1')
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'scripts/odn-traceability.mjs') -Destination (Join-Path $canonical 'scripts/odn-traceability.mjs')
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'scripts/check-scaffold-freshness.ps1') -Destination (Join-Path $canonical 'scripts/check-scaffold-freshness.ps1')
    Copy-Item -LiteralPath (Join-Path $repositoryRoot 'artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json') -Destination (Join-Path $canonical 'artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json')
    Set-Content -LiteralPath (Join-Path $canonical 'README.md') -Value 'baseline' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'SCAFFOLD_VERSION.md') -Value '- version: `3.0.0`' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'AGENTS.md') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'COMMANDS.md') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'artifacts/operations/WORKFLOW_STATE.md') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'artifacts/operations/CURRENT_PHASE.md') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'artifacts/operations/CURRENT_TASK.md') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'artifacts/operations/SESSION_LOG.md') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'artifacts/operations/AGENT_ACTIVITY_LOG.md') -Value "snapshot`nfixture" -NoNewline
    Invoke-Git $canonical @('add', '.')
    Invoke-Git $canonical @('commit', '-m', 'baseline')
    Invoke-Git $canonical @('remote', 'add', 'origin', 'https://github.com/odonplay/odonplay-agent-scaffold.git')
    & git clone --quiet $canonical $projectScaffold
    if ($LASTEXITCODE -ne 0) { throw 'Unable to clone Project Scaffold fixture.' }
    Move-Item -LiteralPath (Join-Path $projectScaffold '.git') -Destination (Join-Path $projectScaffold '.git.project-scaffold-archive')
    New-Item -ItemType Directory -Path (Join-Path $target 'artifacts/shared') -Force | Out-Null
    Invoke-Git $target @('init')
    Invoke-Git $target @('config', 'user.email', 'fixture@example.test')
    Invoke-Git $target @('config', 'user.name', 'Fixture')
    Set-Content -LiteralPath (Join-Path $target 'app.txt') -Value 'target must not change' -NoNewline
    Set-Content -LiteralPath (Join-Path $target 'artifacts/shared/PROJECT_STATE.md') -Value 'client safe' -NoNewline
    Invoke-Git $target @('add', '.')
    Invoke-Git $target @('commit', '-m', 'target baseline')
    $schemaVersion = (Get-Content -Raw (Join-Path $canonical 'artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json') | ConvertFrom-Json).schema_version
    $localTrace = Join-Path $projectScaffold 'artifacts/traceability-local/demo'
    New-Item -ItemType Directory -Path (Join-Path $localTrace 'migration') -Force | Out-Null
    @{ migration_status = 'completed'; schema_version = $schemaVersion } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $localTrace 'PROJECT_ADOPTION.json')
    Set-Content -LiteralPath (Join-Path $localTrace 'migration/MIGRATION_RECEIPT.json') -Value '{"status":"completed"}' -NoNewline
    @{ workspace_type='project_scaffold'; canonical_master_scaffold=$canonical; git_root_status='archived_local_not_a_commit_source'; git_archive='.git.project-scaffold-archive'; target_project_detected=$true } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $projectScaffold '.project-scaffold.json')
    Set-Content -LiteralPath (Join-Path $canonical 'README.md') -Value 'generic update one' -NoNewline
    Invoke-Git $canonical @('add', 'README.md')
    Invoke-Git $canonical @('commit', '-m', 'generic update one')
    $targetHashBefore = (Get-FileHash -LiteralPath (Join-Path $target 'app.txt') -Algorithm SHA256).Hash
    $result = & powershell -NoProfile -File $reconcileScript -ProjectScaffoldPath $projectScaffold -TargetPath $target | ConvertFrom-Json
    if ($result.status -ne 'reconciled') { throw "Expected reconciled status, got $($result.status)." }
    if ((Get-Content -Raw (Join-Path $projectScaffold 'README.md')) -ne 'generic update one') { throw 'Generic root update was not synchronized.' }
    if ((Get-FileHash -LiteralPath (Join-Path $target 'app.txt') -Algorithm SHA256).Hash -ne $targetHashBefore) { throw 'Target Project content changed.' }
    if (-not [string]::IsNullOrWhiteSpace((& git -C $target status --porcelain))) { throw 'Target Project Git status changed.' }
    if (Test-Path -LiteralPath (Join-Path $projectScaffold '.git')) { throw 'Project Scaffold root Git was reactivated.' }
    Set-Content -LiteralPath (Join-Path $projectScaffold 'README.md') -Value 'local project context' -NoNewline
    Set-Content -LiteralPath (Join-Path $canonical 'README.md') -Value 'generic update two' -NoNewline
    Invoke-Git $canonical @('add', 'README.md')
    Invoke-Git $canonical @('commit', '-m', 'generic update two')
    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        & powershell -NoProfile -File $reconcileScript -ProjectScaffoldPath $projectScaffold -TargetPath $target 2>$null | Out-Null
        $blocked = $LASTEXITCODE -ne 0
    } finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
    if (-not $blocked) { throw 'Expected local Project Scaffold conflict to block reconciliation.' }
    if ((Get-Content -Raw (Join-Path $projectScaffold 'README.md')) -ne 'local project context') { throw 'Conflict handling overwrote local Project Scaffold content.' }
    'RECONCILE_PROJECT_SCAFFOLD_TESTS_PASS'
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) { Remove-Item -LiteralPath $fixtureRoot -Recurse -Force }
}
