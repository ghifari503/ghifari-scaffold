[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$ProjectPath,
    [switch]$Update
)

$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath -ErrorAction Stop).Path
$scaffoldRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ($resolvedProject.TrimEnd('\') -eq $scaffoldRoot.TrimEnd('\')) {
    throw 'Refusing to update Graphify for the master scaffold root. Select a target project instead.'
}

if (-not (Test-Path -LiteralPath (Join-Path $resolvedProject '.git'))) {
    throw 'The selected path must be a Git repository.'
}
if (-not (Get-Command uv -ErrorAction SilentlyContinue)) { throw 'uv is required to update Graphify.' }
if (-not (Get-Command graphify -ErrorAction SilentlyContinue)) { throw 'Graphify is not installed. Use setup-graphify-project.ps1 first.' }

$before = (graphify --version | Select-Object -First 1).Trim()
if (-not $Update) {
    [pscustomobject]@{
        project_path = $resolvedProject
        installed_version = $before
        installation_scope = 'developer_user_level_uv_tool'
        action = 'confirmation_required'
    } | ConvertTo-Json -Compress
    return
}

if ($PSCmdlet.ShouldProcess('developer user-level uv tool environment', 'Upgrade graphifyy')) { uv tool upgrade graphifyy }
$after = (graphify --version | Select-Object -First 1).Trim()

[pscustomobject]@{
    project_path = $resolvedProject
    previous_version = $before
    installed_version = $after
    installation_scope = 'developer_user_level_uv_tool'
    target_runtime_files_created = $false
    graph_rebuild_required = $true
    shared_context_action = 'Record the new Graphify version, rebuild status, and next action in Master Scaffold artifacts/traceability/[project]/ internal state.'
} | ConvertTo-Json -Compress
