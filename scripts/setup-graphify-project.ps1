[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$ProjectPath,
    [ValidateSet('codex', 'claude', 'gemini')]
    [string[]]$Runtime = @('codex', 'claude', 'gemini'),
    [switch]$Install,
    [switch]$InstallPrerequisite,
    [switch]$EnableAlwaysOn
)

$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath -ErrorAction Stop).Path
$scaffoldRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ($resolvedProject.TrimEnd('\') -eq $scaffoldRoot.TrimEnd('\')) {
    throw 'Refusing to install Graphify in the master scaffold root. Select a target project instead.'
}

if (-not (Test-Path -LiteralPath (Join-Path $resolvedProject '.git'))) {
    throw 'The selected path must be a Git repository so graph status can be carried safely between developers.'
}

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    if (-not $InstallPrerequisite) {
        throw 'uv is required. Rerun with -InstallPrerequisite after confirming its local installation.'
    }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'uv is missing and winget is unavailable. Install uv manually, then rerun this helper.'
    }
    if ($PSCmdlet.ShouldProcess('local computer', 'Install uv with winget')) {
        winget install --id astral-sh.uv --exact --accept-package-agreements --accept-source-agreements
    }
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        throw 'uv was installed but is not available in this shell yet. Open a new terminal, then rerun this helper.'
    }
}

if (-not (Get-Command graphify -ErrorAction SilentlyContinue)) {
    if (-not $Install) {
        throw 'Graphify is not installed. Rerun with -Install after confirming the package installation.'
    }
    if ($PSCmdlet.ShouldProcess('local uv tool environment', 'Install graphifyy')) {
        uv tool install graphifyy
    }
}

Push-Location -LiteralPath $resolvedProject
try {
    foreach ($platform in $Runtime) {
        if ($PSCmdlet.ShouldProcess($resolvedProject, "Register Graphify for $platform")) {
            graphify install --project --platform $platform
        }
    }

    if ($EnableAlwaysOn) {
        if (-not (Test-Path -LiteralPath (Join-Path $resolvedProject 'graphify-out\graph.json'))) {
            throw 'Build the knowledge graph first, then rerun with -EnableAlwaysOn.'
        }
        foreach ($platform in $Runtime) {
            if ($PSCmdlet.ShouldProcess($resolvedProject, "Enable always-on Graphify guidance for $platform")) {
                graphify $platform install
            }
        }
    }
} finally {
    Pop-Location
}

if ($EnableAlwaysOn) {
    Write-Host 'Always-on Graphify guidance is enabled for the selected runtimes.'
} else {
    Write-Host 'Graphify is registered. Let the active agent present the graph build/update choice before running Graphify.'
}
