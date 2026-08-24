[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [string]$ProjectPath,
    [switch]$Install,
    [switch]$InstallPrerequisite
)

$resolvedProject = (Resolve-Path -LiteralPath $ProjectPath -ErrorAction Stop).Path
$scaffoldRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if ($resolvedProject.TrimEnd('\') -eq $scaffoldRoot.TrimEnd('\')) {
    throw 'Refusing to prepare Graphify for the master scaffold root. Select a target project instead.'
}
$updaterRoot = (Join-Path $scaffoldRoot 'development/_framework-updater').TrimEnd('\', '/')
$updaterPrefix = $updaterRoot + [IO.Path]::DirectorySeparatorChar
if ($resolvedProject.TrimEnd('\', '/').Equals($updaterRoot, [StringComparison]::OrdinalIgnoreCase) -or $resolvedProject.StartsWith($updaterPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'The framework updater and all of its descendants are infrastructure and must never be a Graphify target.'
}

if (-not (Test-Path -LiteralPath (Join-Path $resolvedProject '.git'))) {
    throw 'The selected path must be a Git repository so graph status can be carried safely between developers.'
}

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    if (-not $InstallPrerequisite) {
        throw 'uv is required. Rerun with -InstallPrerequisite only after separately confirming its user-level installation.'
    }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'uv is missing and winget is unavailable. Install uv manually, then rerun this helper.'
    }
    if ($PSCmdlet.ShouldProcess('developer computer', 'Install uv with winget')) {
        winget install --id astral-sh.uv --exact --accept-package-agreements --accept-source-agreements
    }
    if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
        throw 'uv was installed but is not available in this shell yet. Open a new terminal, then rerun this helper.'
    }
}

if (-not (Get-Command graphify -ErrorAction SilentlyContinue)) {
    if (-not $Install) {
        throw 'Graphify is not installed. Rerun with -Install only after confirming the user-level package installation.'
    }
    if ($PSCmdlet.ShouldProcess('developer user-level uv tool environment', 'Install graphifyy')) {
        uv tool install graphifyy
    }
}

$version = (graphify --version | Select-Object -First 1).Trim()
[pscustomobject]@{
    project_path = $resolvedProject
    graphify_installed = $true
    installed_version = $version
    installation_scope = 'developer_user_level_uv_tool'
    target_runtime_files_created = $false
    next_action = 'After explicit approval, build or refresh graphify-out only for this selected target project.'
} | ConvertTo-Json -Compress
