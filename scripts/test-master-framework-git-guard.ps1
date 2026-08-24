[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$guardScript = Join-Path $PSScriptRoot 'unstage-master-framework-root.sh'
$initializeScript = Join-Path $PSScriptRoot 'initialize-project-scaffold.ps1'
$guardScriptForBash = $guardScript.Replace('\', '/')
$gitExecutable = (Get-Command git -ErrorAction Stop).Source
$gitInstallationRoot = Split-Path -Parent (Split-Path -Parent $gitExecutable)
$gitBash = Join-Path $gitInstallationRoot 'bin/bash.exe'
if (-not (Test-Path -LiteralPath $gitBash -PathType Leaf)) { throw "Git Bash was not found at $gitBash" }
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('master-framework-git-guard-' + [guid]::NewGuid().ToString('N'))

function Invoke-Git([string]$Path, [string[]]$Arguments) {
    & git -C $Path @Arguments | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Git failed: $($Arguments -join ' ')" }
}

try {
    $frameworkRoot = Join-Path $fixtureRoot 'framework'
    $workingProject = Join-Path $frameworkRoot 'development/demo'
    New-Item -ItemType Directory -Path $workingProject -Force | Out-Null

    Invoke-Git $frameworkRoot @('init')
    Invoke-Git $frameworkRoot @('config', 'user.email', 'fixture@example.test')
    Invoke-Git $frameworkRoot @('config', 'user.name', 'Fixture')
    Set-Content -LiteralPath (Join-Path $frameworkRoot 'baseline.txt') -Value 'baseline' -NoNewline
    Invoke-Git $frameworkRoot @('add', 'baseline.txt')
    Invoke-Git $frameworkRoot @('commit', '-m', 'baseline')
    Set-Content -LiteralPath (Join-Path $frameworkRoot '.project-scaffold.json') -Value '{"workspace_type":"project_scaffold"}' -NoNewline
    Set-Content -LiteralPath (Join-Path $frameworkRoot 'local-context.txt') -Value 'must remain local' -NoNewline
    Invoke-Git $frameworkRoot @('add', 'local-context.txt')

    Invoke-Git $workingProject @('init')
    Invoke-Git $workingProject @('config', 'user.email', 'fixture@example.test')
    Invoke-Git $workingProject @('config', 'user.name', 'Fixture')
    Set-Content -LiteralPath (Join-Path $workingProject 'app.txt') -Value 'baseline' -NoNewline
    Invoke-Git $workingProject @('add', 'app.txt')
    Invoke-Git $workingProject @('commit', '-m', 'baseline')
    Set-Content -LiteralPath (Join-Path $workingProject 'app.txt') -Value 'target change' -NoNewline
    Invoke-Git $workingProject @('add', 'app.txt')

    Push-Location $frameworkRoot
    try {
        $previousErrorActionPreference = $ErrorActionPreference
        try {
            $ErrorActionPreference = 'Continue'
            & $gitBash $guardScriptForBash 2>&1 | Out-Null
            $guardExit = $LASTEXITCODE
        } finally {
            $ErrorActionPreference = $previousErrorActionPreference
        }
    } finally {
        Pop-Location
    }

    if ($guardExit -eq 0) { throw 'Expected the Master Framework root guard to reject the commit.' }
    if (-not [string]::IsNullOrWhiteSpace((& git -C $frameworkRoot diff --cached --name-only))) { throw 'Master Framework root index was not fully unstaged.' }
    if ((Get-Content -Raw -LiteralPath (Join-Path $frameworkRoot 'local-context.txt')) -ne 'must remain local') { throw 'The guard changed the root working file.' }
    if ((& git -C $workingProject diff --cached --name-only).Trim() -ne 'app.txt') { throw 'The guard changed the Working Project index.' }

    $conversionRoot = Join-Path $fixtureRoot 'conversion'
    $conversionTarget = Join-Path $conversionRoot 'development/demo'
    New-Item -ItemType Directory -Path $conversionTarget -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $conversionRoot '.githooks') -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $conversionRoot '.githooks/pre-commit') -Value 'fixture' -NoNewline
    Set-Content -LiteralPath (Join-Path $conversionRoot '.githooks/pre-push') -Value 'fixture' -NoNewline
    Invoke-Git $conversionRoot @('init')
    Invoke-Git $conversionRoot @('config', 'user.email', 'fixture@example.test')
    Invoke-Git $conversionRoot @('config', 'user.name', 'Fixture')
    Set-Content -LiteralPath (Join-Path $conversionRoot 'baseline.txt') -Value 'baseline' -NoNewline
    Invoke-Git $conversionRoot @('add', 'baseline.txt')
    Invoke-Git $conversionRoot @('commit', '-m', 'baseline')
    Invoke-Git $conversionTarget @('init')
    Set-Content -LiteralPath (Join-Path $conversionRoot 'staged-local.txt') -Value 'preserve me' -NoNewline
    Invoke-Git $conversionRoot @('add', 'staged-local.txt')

    $conversion = & powershell -NoProfile -File $initializeScript -ProjectScaffoldPath $conversionRoot | ConvertFrom-Json
    if ($conversion.result -ne 'initialized') { throw 'Expected Master Framework initialization to complete.' }
    if (Test-Path -LiteralPath (Join-Path $conversionRoot '.git')) { throw 'Initialization left an active root Git directory.' }
    if ((Get-Content -Raw -LiteralPath (Join-Path $conversionRoot 'staged-local.txt')) -ne 'preserve me') { throw 'Initialization changed a staged working file.' }
    $archivedGit = [string]$conversion.git_archive
    $archivedIndex = & git "--git-dir=$archivedGit" "--work-tree=$conversionRoot" diff --cached --name-only
    if ($LASTEXITCODE -ne 0) { throw 'Unable to inspect the archived Master Framework root index.' }
    if (-not [string]::IsNullOrWhiteSpace($archivedIndex)) { throw 'Initialization archived a non-empty root index.' }
    $archivedHooksPath = (& git "--git-dir=$archivedGit" config --get core.hooksPath).Trim()
    if ($archivedHooksPath -ne '.githooks') { throw 'Initialization did not preserve strict hooks in the archived Git metadata.' }

    'MASTER_FRAMEWORK_GIT_GUARD_TESTS_PASS'
} finally {
    if (Test-Path -LiteralPath $fixtureRoot) { Remove-Item -LiteralPath $fixtureRoot -Recurse -Force }
}
