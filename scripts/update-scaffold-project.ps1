[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string]$TargetPath,
    [string]$RepositoryRoot,
    [switch]$Apply,
    [string]$ReportId
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) { $RepositoryRoot = Split-Path -Parent $PSScriptRoot }
function Stop-Update([string]$Message) { throw ('SCAFFOLD_ADOPTION_BLOCKED: {0}' -f $Message) }
function Get-GitText([string]$Path, [string[]]$Arguments) {
    $result = & git -C $Path @Arguments 2>$null
    if ($LASTEXITCODE -ne 0) { return $null }
    return ($result -join [Environment]::NewLine).Trim()
}

$master = (Resolve-Path -LiteralPath $RepositoryRoot).Path.TrimEnd('\', '/')
$target = (Resolve-Path -LiteralPath $TargetPath).Path.TrimEnd('\', '/')
$developmentRoot = Join-Path $master 'development'
$developmentPrefix = $developmentRoot.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
if ($target -eq $master) { Stop-Update 'The master scaffold itself is never an adoption target.' }
if (-not $target.StartsWith($developmentPrefix, [StringComparison]::OrdinalIgnoreCase)) { Stop-Update 'Target must be under development/.' }
$gitRoot = Get-GitText $target @('rev-parse', '--show-toplevel')
if ([string]::IsNullOrWhiteSpace($gitRoot)) { Stop-Update 'Target is not a Git repository.' }
if ((Resolve-Path -LiteralPath $gitRoot).Path.TrimEnd('\', '/') -ne $target) { Stop-Update 'Target path must be its own Git repository root.' }

$versionContent = Get-Content -Raw -LiteralPath (Join-Path $master 'SCAFFOLD_VERSION.md')
$versionMatch = [regex]::Match($versionContent, '(?m)^-\s*version:\s*`?([^`\r\n]+)`?\s*$')
if (-not $versionMatch.Success) { Stop-Update 'Master scaffold version cannot be read.' }
$version = $versionMatch.Groups[1].Value.Trim().Trim('`')
$dirtyPaths = Get-GitText $target @('status', '--porcelain')
$sharedRoot = Join-Path $target 'artifacts/shared'
$project = (Split-Path -Leaf $target).ToLowerInvariant()
$odnTool = Join-Path $PSScriptRoot 'odn-traceability.mjs'
$odnReceipt = Join-Path $master ('artifacts/traceability-local/{0}/migration/MIGRATION_RECEIPT.json' -f $project)
$odnSchemaFile = Join-Path $master 'artifacts/traceability/MASTER_SCAFFOLD_SCHEMA.json'
if (-not (Test-Path -LiteralPath $odnSchemaFile -PathType Leaf)) { Stop-Update 'Master ODN schema authority is missing.' }
$odnMasterSchema = (Get-Content -Raw -LiteralPath $odnSchemaFile | ConvertFrom-Json).schema_version
if ($null -eq $odnMasterSchema) { Stop-Update 'Master ODN schema authority is invalid.' }
$odnAdoptionFile = Join-Path $master ('artifacts/traceability-local/{0}/PROJECT_ADOPTION.json' -f $project)
$odnAdoption = if (Test-Path -LiteralPath $odnAdoptionFile -PathType Leaf) { Get-Content -Raw -LiteralPath $odnAdoptionFile | ConvertFrom-Json } else { $null }
$odnAdopted = (Test-Path -LiteralPath $odnReceipt -PathType Leaf) -and $null -ne $odnAdoption -and $odnAdoption.migration_status -eq 'completed' -and [int]$odnAdoption.schema_version -eq [int]$odnMasterSchema
$odnDryRun = $null
if (-not $odnAdopted -and (Test-Path -LiteralPath $sharedRoot -PathType Container)) {
    $odnOutput = & node $odnTool migrate-shared --master $master --project $project --target $target
    if ($LASTEXITCODE -ne 0) { Stop-Update 'ODN first-adoption dry-run failed.' }
    $odnDryRun = ($odnOutput -join [Environment]::NewLine) | ConvertFrom-Json
}
$legacyPaths = @(@('AGENTS.md', 'CLAUDE.md', 'GEMINI.md', '.codex', '.claude', '.agents') | ForEach-Object { Join-Path $target $_ } | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object { $_.Substring($target.Length).TrimStart('\', '/') })
$head = Get-GitText $master @('rev-parse', 'HEAD')
$bytes = [Text.Encoding]::UTF8.GetBytes(('{0}|{1}|{2}' -f $target, $version, $head))
$reportIdComputed = (([Security.Cryptography.SHA256]::Create().ComputeHash($bytes) | ForEach-Object ToString x2) -join '').Substring(0, 12)
$status = if ($dirtyPaths) { 'blocked_dirty_target' } elseif (-not (Test-Path -LiteralPath $sharedRoot)) { 'blocked_missing_shared_context' } elseif ($legacyPaths.Count -gt 0) { 'blocked_legacy_scaffold_copy' } elseif (-not $odnAdopted) { 'blocked_odn_first_adoption_required' } else { 'ready_for_opt_in_apply' }
$result = [ordered]@{ report_id=$reportIdComputed; mode=$(if ($Apply) {'apply'} else {'dry_run'}); status=$status; master_version=$version; target=$target; target_branch=(Get-GitText $target @('branch','--show-current')); target_dirty=[bool]$dirtyPaths; shared_context_present=(Test-Path -LiteralPath $sharedRoot); legacy_scaffold_paths=@($legacyPaths); odn_schema_version=$odnMasterSchema; odn_project_adoption=$odnAdoption; odn_first_adoption_completed=$odnAdopted; odn_first_adoption_dry_run=$odnDryRun; apply_effect='Create one new versioned Master Scaffold adoption receipt only; never copy or overwrite master files into the target.' }
if (-not $Apply) { $result | ConvertTo-Json -Depth 4; exit 0 }
if ($ReportId -ne $reportIdComputed) { Stop-Update ('Apply requires the current dry-run report id: {0}' -f $reportIdComputed) }
if ($status -ne 'ready_for_opt_in_apply') { Stop-Update ('Apply is not safe while status is {0}.' -f $status) }
$receiptDirectory = Join-Path $master ('artifacts/traceability-local/{0}/scaffold-updates' -f $project)
$receiptPath = Join-Path $receiptDirectory ('{0}-{1}.md' -f $version, $reportIdComputed)
if (Test-Path -LiteralPath $receiptPath) { Stop-Update 'Versioned adoption receipt already exists; no overwrite is allowed.' }
New-Item -ItemType Directory -Path $receiptDirectory -Force | Out-Null
$receipt = @(
    '# Scaffold Adoption Receipt',
    '',
    ('- master_version: `{0}`' -f $version),
    ('- report_id: `{0}`' -f $reportIdComputed),
    ('- adopted_at: `{0}`' -f (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')),
    ('- target_branch: `{0}`' -f (Get-GitText $target @('branch','--show-current'))),
    '- effect: `Master runtime governance is now used from the updated workspace. No target source, dependency, environment, or existing documentation file was changed.`',
    '- next_action: `Keep this internal receipt in Project Scaffold local context; do not commit it to either repository.`'
) -join [Environment]::NewLine
Set-Content -LiteralPath $receiptPath -Value $receipt -NoNewline
$result.status = 'applied_receipt_created'
$result.receipt_path = $receiptPath.Substring($master.Length).TrimStart('\', '/')
$result | ConvertTo-Json -Depth 4
