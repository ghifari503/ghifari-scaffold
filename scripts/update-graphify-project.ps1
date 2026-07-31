[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$ProjectPath,
    [ValidateSet('codex', 'claude', 'gemini')]
    [string[]]$Runtime = @('codex', 'claude', 'gemini'),
    [switch]$Update
)

$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath -ErrorAction Stop).Path
$scaffoldRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ($resolvedProject.TrimEnd('\') -eq $scaffoldRoot.TrimEnd('\')) {
    throw 'Refusing to update Graphify in the master scaffold root. Select a target project instead.'
}

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) { throw 'uv is required to update Graphify.' }
if (-not (Get-Command graphify -ErrorAction SilentlyContinue)) { throw 'Graphify is not installed. Use setup-graphify-project.ps1 first.' }

$before = (graphify --version | Select-Object -First 1).Trim()
if (-not $Update) {
    [pscustomobject]@{ project_path = $resolvedProject; installed_version = $before; action = 'confirmation_required' } | ConvertTo-Json -Compress
    return
}

if ($PSCmdlet.ShouldProcess('local uv tool environment', 'Upgrade graphifyy')) { uv tool upgrade graphifyy }
$after = (graphify --version | Select-Object -First 1).Trim()

Push-Location -LiteralPath $resolvedProject
try {
    foreach ($platform in $Runtime) {
        if ($PSCmdlet.ShouldProcess($resolvedProject, "Refresh Graphify registration for $platform")) { graphify install --project --platform $platform }
    }
} finally { Pop-Location }

[pscustomobject]@{
    project_path = $resolvedProject
    previous_version = $before
    installed_version = $after
    graph_rebuild_required = $true
    shared_context_action = 'Record the new Graphify version, rebuild status, and next action in artifacts/shared/PROJECT_STATE.md and ACTIVE_CONTEXT.md.'
} | ConvertTo-Json -Compress
