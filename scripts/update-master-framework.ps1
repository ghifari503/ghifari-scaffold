[CmdletBinding(DefaultParameterSetName = 'Update')]
param(
    [Parameter(Mandatory)]
    [string]$FrameworkRoot,
    [string]$UpdaterPath,
    [Parameter(ParameterSetName = 'Update')]
    [switch]$Apply,
    [Parameter(ParameterSetName = 'Update')]
    [string]$ReportId,
    [Parameter(Mandatory, ParameterSetName = 'Rollback')]
    [switch]$Rollback,
    [Parameter(Mandatory, ParameterSetName = 'Rollback')]
    [string]$SnapshotId
)

$ErrorActionPreference = 'Stop'
$officialRemote = 'https://github.com/odonplay/odonplay-agent-scaffold'
$canonicalMasterPath = 'E:\www\project-scaffold'
$lockPath = $null
$updateLock = $null
$lockOwned = $false

if ($null -eq ('ScaffoldPhysicalPath' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.IO;
using System.Text;
using Microsoft.Win32.SafeHandles;
using System.Runtime.InteropServices;
public static class ScaffoldPhysicalPath {
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern SafeFileHandle CreateFile(string name, uint access, FileShare share, IntPtr security, FileMode mode, uint flags, IntPtr template);
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern uint GetFinalPathNameByHandle(SafeFileHandle handle, StringBuilder path, uint length, uint flags);
    public static string Directory(string path) {
        using (var handle = CreateFile(path, 0, FileShare.ReadWrite | FileShare.Delete, IntPtr.Zero, FileMode.Open, 0x02000000, IntPtr.Zero)) {
            if (handle.IsInvalid) throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
            var buffer = new StringBuilder(32768);
            uint length = GetFinalPathNameByHandle(handle, buffer, (uint)buffer.Capacity, 0);
            if (length == 0 || length >= buffer.Capacity) throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());
            return buffer.ToString();
        }
    }
}
'@
}

function Stop-FrameworkUpdate([string]$Message) {
    throw ('FRAMEWORK_UPDATE_BLOCKED: {0}' -f $Message)
}

function Release-UpdateLock {
    if ($null -ne $script:updateLock) {
        $script:updateLock.Dispose()
        $script:updateLock = $null
    }
    if ($script:lockOwned -and -not [string]::IsNullOrWhiteSpace([string]$script:lockPath) -and (Test-Path -LiteralPath $script:lockPath -PathType Leaf)) {
        Remove-Item -LiteralPath $script:lockPath -Force -ErrorAction SilentlyContinue
    }
    $script:lockOwned = $false
}

trap {
    $failure = $_
    Release-UpdateLock
    throw $failure
}

function Resolve-Directory([string]$Path, [string]$Label) {
    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        Stop-FrameworkUpdate ("{0} directory does not exist: {1}" -f $Label, $Path)
    }
    return (Resolve-Path -LiteralPath $Path -ErrorAction Stop).Path.TrimEnd('\', '/')
}

function Resolve-PhysicalDirectory([string]$Path, [string]$Label) {
    $resolved = Resolve-Directory $Path $Label
    try { $physical = [ScaffoldPhysicalPath]::Directory($resolved) } catch { Stop-FrameworkUpdate ('Unable to resolve physical {0}: {1}' -f $Label, $_.Exception.Message) }
    if ($physical.StartsWith('\\?\UNC\', [StringComparison]::OrdinalIgnoreCase)) { $physical = '\\' + $physical.Substring(8) }
    elseif ($physical.StartsWith('\\?\', [StringComparison]::OrdinalIgnoreCase)) { $physical = $physical.Substring(4) }
    return $physical.TrimEnd('\', '/')
}

function Get-GitText([string]$Repository, [string[]]$Arguments, [switch]$Required) {
    $previousPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & git -C $Repository @Arguments 2>$null
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousPreference
    }
    if ($exitCode -ne 0) {
        if ($Required) { Stop-FrameworkUpdate ('Git command failed: git -C "{0}" {1}' -f $Repository, ($Arguments -join ' ')) }
        return $null
    }
    return ($output -join [Environment]::NewLine).Trim()
}

function Get-GitDirText([string]$GitDirectory, [string[]]$Arguments, [switch]$Required) {
    $previousPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & git --git-dir=$GitDirectory @Arguments 2>$null
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousPreference
    }
    if ($exitCode -ne 0) {
        if ($Required) { Stop-FrameworkUpdate ('Git archive command failed: git --git-dir="{0}" {1}' -f $GitDirectory, ($Arguments -join ' ')) }
        return $null
    }
    return ($output -join [Environment]::NewLine).Trim()
}

function Normalize-Remote([string]$Remote) {
    if ([string]::IsNullOrWhiteSpace($Remote)) { return '' }
    $normalized = $Remote.Trim().TrimEnd('/')
    if ($normalized.EndsWith('.git', [StringComparison]::OrdinalIgnoreCase)) {
        $normalized = $normalized.Substring(0, $normalized.Length - 4)
    }
    if ($normalized -eq 'git@github.com:odonplay/odonplay-agent-scaffold') { return $officialRemote }
    return $normalized.ToLowerInvariant()
}

function Get-ScaffoldVersion([string]$Root) {
    $versionFile = Join-Path $Root 'SCAFFOLD_VERSION.md'
    if (-not (Test-Path -LiteralPath $versionFile -PathType Leaf)) { return $null }
    $match = [regex]::Match((Get-Content -Raw -LiteralPath $versionFile), '(?m)^-\s*version:\s*`?([^`\r\n]+)`?\s*$')
    if (-not $match.Success) { return $null }
    return $match.Groups[1].Value.Trim().Trim('`')
}

function Normalize-RelativePath([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path) -or [IO.Path]::IsPathRooted($Path)) {
        Stop-FrameworkUpdate ('Unsafe updater path: {0}' -f $Path)
    }
    $normalized = $Path.Replace('\', '/')
    $segments = @($normalized.Split('/'))
    if ($segments.Count -eq 0) { Stop-FrameworkUpdate ('Unsafe updater path: {0}' -f $Path) }
    foreach ($segment in $segments) {
        if ([string]::IsNullOrWhiteSpace($segment) -or $segment -in @('.', '..') -or $segment.Contains(':') -or $segment -match '[\x00-\x1f]' -or $segment -match '[\. ]$') {
            Stop-FrameworkUpdate ('Unsafe updater path segment in: {0}' -f $Path)
        }
    }
    return ($segments -join '/')
}

function Test-ProtectedPath([string]$RelativePath) {
    $path = (Normalize-RelativePath $RelativePath).ToLowerInvariant()
    $protectedRoots = @('artifacts', 'plan', 'dev-doc', 'development')
    foreach ($rootName in $protectedRoots) {
        if ($path -eq $rootName -or $path.StartsWith($rootName + '/')) { return $true }
    }
    if ($path -eq '.project-scaffold.json' -or $path -eq '.git' -or $path.StartsWith('.git/')) { return $true }
    if ($path -eq '.codex/model-routing.local.json') { return $true }
    if ($path -in @('.claude/settings.local.json', '.gemini/settings.local.json', '.agents/settings.local.json')) { return $true }
    if ($path -eq '.env' -or ($path.StartsWith('.env.') -and -not $path.EndsWith('.example'))) { return $true }
    return $false
}

function Assert-SafeArchiveName([string]$Name) {
    if ([string]::IsNullOrWhiteSpace($Name) -or $Name -notmatch '^\.git\.(?:project-scaffold|master-framework)-archive-[A-Za-z0-9._-]+$') {
        Stop-FrameworkUpdate ('Unsafe legacy Git archive name: {0}' -f $Name)
    }
}

function Assert-NoReparsePoint([string]$Root, [string]$RelativePath) {
    $current = $Root
    foreach ($segment in (Normalize-RelativePath $RelativePath).Split('/')) {
        $current = Join-Path $current $segment
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                Stop-FrameworkUpdate ('Reparse point or symbolic link is not allowed in an update path: {0}' -f $current)
            }
        }
    }
}

function Get-SafeDestination([string]$Root, [string]$RelativePath) {
    $relative = Normalize-RelativePath $RelativePath
    if (Test-ProtectedPath $relative) { Stop-FrameworkUpdate ('Protected local path cannot be updated or restored: {0}' -f $relative) }
    $destination = [IO.Path]::GetFullPath((Join-Path $Root $relative))
    $prefix = $Root.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
    if (-not $destination.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        Stop-FrameworkUpdate ('Updater path escapes the Master Framework root: {0}' -f $relative)
    }
    Assert-NoReparsePoint $Root $relative
    return $destination
}

function Get-Sha256([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Get-FileObjectHash([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return $null }
    $hash = & git hash-object -- $Path 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate ('Unable to hash file: {0}' -f $Path) }
    return ($hash -join '').Trim()
}

function Get-NullableHash($Value) {
    $text = [string]$Value
    if ([string]::IsNullOrWhiteSpace($text)) { return $null }
    return $text
}

function Get-CommitBlobHash([string]$Repository, [string]$Commit, [string]$RelativePath) {
    $value = Get-GitText $Repository @('rev-parse', ('{0}:{1}' -f $Commit, $RelativePath))
    if ([string]::IsNullOrWhiteSpace($value)) { return $null }
    return $value
}

function Get-TrackedPaths([string]$Repository, [string]$Commit) {
    $output = Get-GitText $Repository @('ls-tree', '-r', '--name-only', $Commit) -Required
    if ([string]::IsNullOrWhiteSpace($output)) { return @() }
    return @($output -split '\r?\n' | ForEach-Object { Normalize-RelativePath $_ } | Where-Object { -not (Test-ProtectedPath $_) })
}

function Get-CurrentSourcePaths([string]$Repository) {
    $output = Get-GitText $Repository @('ls-files') -Required
    if ([string]::IsNullOrWhiteSpace($output)) { return @() }
    return @($output -split '\r?\n' | ForEach-Object { Normalize-RelativePath $_ } | Where-Object { -not (Test-ProtectedPath $_) })
}

function ConvertTo-HashTable($Object) {
    $table = @{}
    if ($null -eq $Object) { return $table }
    foreach ($property in $Object.PSObject.Properties) { $table[$property.Name] = [string]$property.Value }
    return $table
}

function Get-ReportHash([string]$Text) {
    $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
    $hash = [Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
    return (($hash | ForEach-Object ToString x2) -join '').Substring(0, 16)
}

function Set-JsonAtomic([string]$Path, $Value, [int]$Depth = 8) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force | Out-Null
    $temporary = '{0}.write-{1}-{2}.tmp' -f $Path, $PID, ([Guid]::NewGuid().ToString('N').Substring(0, 8))
    try {
        $Value | ConvertTo-Json -Depth $Depth | Set-Content -LiteralPath $temporary -Encoding utf8
        Move-Item -LiteralPath $temporary -Destination $Path -Force
    } finally {
        if (Test-Path -LiteralPath $temporary -PathType Leaf) { Remove-Item -LiteralPath $temporary -Force -ErrorAction SilentlyContinue }
    }
}

function Restore-Snapshot(
    [string]$Root,
    [string]$SnapshotRoot,
    [switch]$RestoreGit,
    [switch]$RestoreMetadata,
    [switch]$VerifyAppliedState,
    [switch]$ValidateOnly,
    [string[]]$OnlyPaths
) {
    $manifestPath = Join-Path $SnapshotRoot 'SNAPSHOT.json'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { Stop-FrameworkUpdate 'Snapshot manifest is missing.' }
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    $selectedEntries = @($manifest.files)
    if ($null -ne $OnlyPaths) {
        $selected = @{}; foreach ($path in $OnlyPaths) { $selected[(Normalize-RelativePath $path)] = $true }
        $selectedEntries = @($selectedEntries | Where-Object { $selected.ContainsKey((Normalize-RelativePath ([string]$_.path))) })
    }

    # Validate the complete restore set before mutating any file.
    foreach ($entry in $selectedEntries) {
        $destination = Get-SafeDestination $Root ([string]$entry.path)
        $currentHash = Get-FileObjectHash $destination
        if ($VerifyAppliedState -and $currentHash -ne (Get-NullableHash $entry.after) -and $currentHash -ne (Get-NullableHash $entry.before)) {
            Stop-FrameworkUpdate ('Rollback refused to overwrite a concurrent edit: {0}' -f $entry.path)
        }
        if ([bool]$entry.existed) {
            $backup = Get-SafeDestination $SnapshotRoot ('files/{0}' -f ([string]$entry.path))
            if (-not (Test-Path -LiteralPath $backup -PathType Leaf)) { Stop-FrameworkUpdate ('Snapshot file is missing: {0}' -f $entry.path) }
            if ((Get-FileObjectHash $backup) -ne [string]$entry.before) { Stop-FrameworkUpdate ('Snapshot content hash mismatch: {0}' -f $entry.path) }
        }
    }
    if ($RestoreMetadata) {
        foreach ($localFile in @('STATE.json', '.project-scaffold.json')) {
            $metadataEntry = @($manifest.local_metadata | Where-Object { $_.name -eq $localFile }) | Select-Object -First 1
            if ($null -ne $metadataEntry -and [bool]$metadataEntry.existed) {
                $metadataBackup = Join-Path $SnapshotRoot ('metadata/{0}' -f $localFile)
                if (-not (Test-Path -LiteralPath $metadataBackup -PathType Leaf) -or (Get-Sha256 $metadataBackup) -ne [string]$metadataEntry.sha256) {
                    Stop-FrameworkUpdate ('Snapshot metadata hash mismatch: {0}' -f $localFile)
                }
            }
        }
    }
    if ($RestoreGit) {
        if (-not [string]::IsNullOrWhiteSpace([string]$manifest.git_archive)) { Assert-SafeArchiveName ([string]$manifest.git_archive) }
        if ($null -ne $manifest.git_index -and [bool]$manifest.git_index.existed) {
            $indexBackup = Join-Path $SnapshotRoot 'metadata/git-index'
            if (-not (Test-Path -LiteralPath $indexBackup -PathType Leaf) -or (Get-Sha256 $indexBackup) -ne [string]$manifest.git_index.sha256) {
                Stop-FrameworkUpdate 'Snapshot legacy Git index integrity check failed.'
            }
        }
    }
    if ($ValidateOnly) { return $manifest }

    foreach ($entry in $selectedEntries) {
        $destination = Get-SafeDestination $Root ([string]$entry.path)
        if ((Get-FileObjectHash $destination) -eq (Get-NullableHash $entry.before)) { continue }
        if ([bool]$entry.existed) {
            $backup = Get-SafeDestination $SnapshotRoot ('files/{0}' -f ([string]$entry.path))
            New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
            $temporary = '{0}.framework-rollback-{1}.tmp' -f $destination, $PID
            Copy-Item -LiteralPath $backup -Destination $temporary -Force
            if ((Get-FileObjectHash $temporary) -ne [string]$entry.before) { Stop-FrameworkUpdate ('Rollback temporary file validation failed: {0}' -f $entry.path) }
            Move-Item -LiteralPath $temporary -Destination $destination -Force
        } elseif (Test-Path -LiteralPath $destination -PathType Leaf) {
            $removedBackup = Get-SafeDestination $SnapshotRoot ('removed-during-rollback/{0}' -f ([string]$entry.path))
            New-Item -ItemType Directory -Path (Split-Path -Parent $removedBackup) -Force | Out-Null
            Move-Item -LiteralPath $destination -Destination $removedBackup -Force
        }
        if ((Get-FileObjectHash $destination) -ne (Get-NullableHash $entry.before)) { Stop-FrameworkUpdate ('Rollback post-write validation failed: {0}' -f $entry.path) }
    }
    if ($RestoreMetadata) {
        foreach ($localFile in @('STATE.json', '.project-scaffold.json')) {
            $metadataEntry = @($manifest.local_metadata | Where-Object { $_.name -eq $localFile }) | Select-Object -First 1
            $destination = if ($localFile -eq 'STATE.json') { Join-Path $Root 'artifacts/framework-update/STATE.json' } else { Join-Path $Root $localFile }
            if ($null -ne $metadataEntry -and [bool]$metadataEntry.existed) {
                $metadataBackup = Join-Path $SnapshotRoot ('metadata/{0}' -f $localFile)
                New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
                Copy-Item -LiteralPath $metadataBackup -Destination $destination -Force
            } elseif (Test-Path -LiteralPath $destination -PathType Leaf) {
                Remove-Item -LiteralPath $destination -Force
            }
        }
    }
    if ($RestoreGit) {
        $activeGit = Join-Path $Root '.git'
        if (-not [string]::IsNullOrWhiteSpace([string]$manifest.git_archive)) {
            Assert-SafeArchiveName ([string]$manifest.git_archive)
            $archivePath = Join-Path $Root ([string]$manifest.git_archive)
            if (-not (Test-Path -LiteralPath $activeGit) -and (Test-Path -LiteralPath $archivePath)) {
                Move-Item -LiteralPath $archivePath -Destination $activeGit
            }
        }
        if ($null -ne $manifest.git_index) {
            $activeIndex = Join-Path $activeGit 'index'
            if ([bool]$manifest.git_index.existed) {
                Copy-Item -LiteralPath (Join-Path $SnapshotRoot 'metadata/git-index') -Destination $activeIndex -Force
            } elseif (Test-Path -LiteralPath $activeIndex -PathType Leaf) {
                Remove-Item -LiteralPath $activeIndex -Force
            }
        }
    }
}

$framework = Resolve-Directory $FrameworkRoot 'Master Framework root'
if (((Get-Item -LiteralPath $framework -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    Stop-FrameworkUpdate 'Master Framework root cannot be a junction, symbolic link, or other reparse point.'
}
$physicalFramework = Resolve-PhysicalDirectory $framework 'Master Framework root'
$physicalCanonical = if (Test-Path -LiteralPath $canonicalMasterPath -PathType Container) { Resolve-PhysicalDirectory $canonicalMasterPath 'canonical Master Scaffold' } else { $canonicalMasterPath.TrimEnd('\', '/') }
if ($physicalFramework.Equals($physicalCanonical, [StringComparison]::OrdinalIgnoreCase)) {
    Stop-FrameworkUpdate 'The canonical Master Scaffold must never be updated through the Master Framework updater.'
}
if ([string]::IsNullOrWhiteSpace($UpdaterPath)) { $UpdaterPath = Join-Path $framework 'development/_framework-updater' }
$updater = Resolve-Directory $UpdaterPath 'Updater repository'
if (((Get-Item -LiteralPath $updater -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    Stop-FrameworkUpdate 'Updater repository root cannot be a junction, symbolic link, or other reparse point.'
}
$physicalUpdater = Resolve-PhysicalDirectory $updater 'Updater repository'
$expectedUpdater = [IO.Path]::GetFullPath((Join-Path $framework 'development/_framework-updater')).TrimEnd('\', '/')
if (-not $updater.Equals($expectedUpdater, [StringComparison]::OrdinalIgnoreCase)) {
    Stop-FrameworkUpdate 'Updater repository must be exactly development/_framework-updater under the selected Master Framework.'
}
if (-not $physicalUpdater.StartsWith(($physicalFramework.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar), [StringComparison]::OrdinalIgnoreCase)) {
    Stop-FrameworkUpdate 'Updater repository physical path escapes the selected Master Framework.'
}
$updaterGitRoot = Get-GitText $updater @('rev-parse', '--show-toplevel') -Required
if (-not (Resolve-Directory $updaterGitRoot 'Updater Git root').Equals($updater, [StringComparison]::OrdinalIgnoreCase)) {
    Stop-FrameworkUpdate 'Updater path is not an independent Git repository root.'
}
if ((Normalize-Remote (Get-GitText $updater @('remote', 'get-url', 'origin') -Required)) -ne $officialRemote) {
    Stop-FrameworkUpdate 'Updater origin is not the official Master Scaffold repository.'
}
if (-not [string]::IsNullOrWhiteSpace((Get-GitText $updater @('status', '--porcelain') -Required))) {
    Stop-FrameworkUpdate 'Updater repository is dirty. Restore it or pull a clean updater before continuing.'
}
$updaterHead = Get-GitText $updater @('rev-parse', 'HEAD') -Required
$updaterBranch = Get-GitText $updater @('branch', '--show-current') -Required
$updaterRemoteHead = Get-GitText $updater @('rev-parse', 'refs/remotes/origin/main') -Required
if ($updaterBranch -ne 'main' -or $updaterHead -ne $updaterRemoteHead) {
    Stop-FrameworkUpdate 'Updater must be on main and exactly match refs/remotes/origin/main. Local updater commits are prohibited.'
}
$availableVersion = Get-ScaffoldVersion $updater
if ([string]::IsNullOrWhiteSpace($availableVersion)) { Stop-FrameworkUpdate 'Updater scaffold version is missing or invalid.' }
$installedVersion = Get-ScaffoldVersion $framework
$frameworkState = if ([string]::IsNullOrWhiteSpace($installedVersion)) { 'legacy_unversioned' } else { 'versioned' }
$stateRoot = Join-Path $framework 'artifacts/framework-update'
$statePath = Join-Path $stateRoot 'STATE.json'
$rollbackJournalPath = Join-Path $stateRoot 'ROLLBACK_IN_PROGRESS.json'
$applyJournalPath = Join-Path $stateRoot 'APPLY_IN_PROGRESS.json'
$lockPath = Join-Path $stateRoot '.update.lock'
Assert-NoReparsePoint $framework 'artifacts/framework-update'
Assert-NoReparsePoint $framework '.project-scaffold.json'
Assert-NoReparsePoint $framework '.git'
$rootGitMarker = Join-Path $framework '.git'
if (Test-Path -LiteralPath $rootGitMarker -PathType Leaf) {
    Stop-FrameworkUpdate 'A linked-worktree .git file is unsupported for a Master Framework root; convert from a normal standalone clone only.'
}
if ($Apply -or $Rollback) {
    New-Item -ItemType Directory -Path $stateRoot -Force | Out-Null
    if (Test-Path -LiteralPath $lockPath -PathType Leaf) {
        try {
            $staleProbe = [IO.File]::Open($lockPath, [IO.FileMode]::Open, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
            $staleProbe.Dispose()
        } catch { Stop-FrameworkUpdate 'Another framework update or rollback is actively holding the update lock.' }
        $recoveryJournalPresent = (Test-Path -LiteralPath $rollbackJournalPath -PathType Leaf) -or (Test-Path -LiteralPath $applyJournalPath -PathType Leaf)
        if (-not $Rollback -or -not $recoveryJournalPresent) { Stop-FrameworkUpdate 'A stale update lock requires review; it may be removed only through journal-backed rollback recovery.' }
        Remove-Item -LiteralPath $lockPath -Force
    }
    try {
        $updateLock = [IO.File]::Open($lockPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
        $lockOwned = $true
    } catch {
        Stop-FrameworkUpdate 'Another framework update or rollback is active, or a stale update lock requires review.'
    }
}
$rollbackJournalEarly = if (Test-Path -LiteralPath $rollbackJournalPath -PathType Leaf) { try { Get-Content -Raw -LiteralPath $rollbackJournalPath | ConvertFrom-Json } catch { Stop-FrameworkUpdate 'Rollback recovery journal is invalid.' } } else { $null }
$applyJournalEarly = if (Test-Path -LiteralPath $applyJournalPath -PathType Leaf) { try { Get-Content -Raw -LiteralPath $applyJournalPath | ConvertFrom-Json } catch { Stop-FrameworkUpdate 'Apply recovery journal is invalid.' } } else { $null }
$state = if (Test-Path -LiteralPath $statePath -PathType Leaf) {
    try { Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json } catch { if ($Rollback -and ($null -ne $rollbackJournalEarly -or $null -ne $applyJournalEarly)) { $null } else { Stop-FrameworkUpdate 'Installed update state is invalid.' } }
} else { $null }
$markerPath = Join-Path $framework '.project-scaffold.json'
$existingMarker = if (Test-Path -LiteralPath $markerPath -PathType Leaf) {
    try { Get-Content -Raw -LiteralPath $markerPath | ConvertFrom-Json } catch { if ($Rollback -and ($null -ne $rollbackJournalEarly -or $null -ne $applyJournalEarly)) { $null } else { Stop-FrameworkUpdate 'Master Framework marker is invalid.' } }
} else { $null }
if (-not $Rollback -and $null -ne $rollbackJournalEarly) { Stop-FrameworkUpdate 'An interrupted rollback requires recovery with its recorded SnapshotId before any update can continue.' }
if (-not $Rollback -and $null -ne $applyJournalEarly) { Stop-FrameworkUpdate 'An interrupted apply requires recovery with its recorded SnapshotId before any update can continue.' }
if ($Rollback) {
    if ($SnapshotId -notmatch '^[a-f0-9]{16}$') { Stop-FrameworkUpdate 'SnapshotId must be the exact 16-character report id.' }
    $rollbackRoot = Join-Path $stateRoot ('snapshots/{0}' -f $SnapshotId)
    $rollbackJournal = $rollbackJournalEarly
    $applyJournal = $applyJournalEarly
    if ($null -eq $state -and $null -eq $rollbackJournal -and $null -eq $applyJournal) { Stop-FrameworkUpdate 'Rollback requires current installed update state or a valid recovery journal.' }
    $rollbackManifest = Get-Content -Raw -LiteralPath (Join-Path $rollbackRoot 'SNAPSHOT.json') | ConvertFrom-Json
    $manifestSha = Get-Sha256 (Join-Path $rollbackRoot 'SNAPSHOT.json')
    if ($null -ne $applyJournal) {
        if ([string]$applyJournal.snapshot_id -ne $SnapshotId -or [string]$applyJournal.snapshot_sha256 -ne $manifestSha) { Stop-FrameworkUpdate 'Apply recovery journal does not match the requested snapshot.' }
    } elseif ($null -ne $rollbackJournal) {
        if ([string]$rollbackJournal.snapshot_id -ne $SnapshotId -or [string]$rollbackJournal.snapshot_sha256 -ne $manifestSha) { Stop-FrameworkUpdate 'Rollback recovery journal does not match the requested snapshot.' }
    } elseif ([string]$rollbackManifest.snapshot_id -ne $SnapshotId -or [string]$state.last_report_id -ne $SnapshotId -or [string]$state.installed_head -ne [string]$rollbackManifest.to_head) {
        Stop-FrameworkUpdate 'Rollback snapshot is not the direct predecessor of the currently installed state.'
    }
    if (($null -eq $rollbackJournal -and $null -eq $applyJournal -and [string]::IsNullOrWhiteSpace([string]$state.snapshot_sha256)) -or ($null -eq $rollbackJournal -and $null -eq $applyJournal -and $manifestSha -ne [string]$state.snapshot_sha256)) {
        Stop-FrameworkUpdate 'Rollback snapshot manifest integrity check failed.'
    }
    if ($null -eq $rollbackJournal -and $null -eq $applyJournal) {
        if ([string]::IsNullOrWhiteSpace([string]$state.installed_marker_sha256) -or (Get-Sha256 $markerPath) -ne [string]$state.installed_marker_sha256) {
            Stop-FrameworkUpdate 'Master Framework marker changed after apply; rollback refuses to overwrite non-updater marker changes.'
        }
    }
    Restore-Snapshot $framework $rollbackRoot -RestoreMetadata -VerifyAppliedState -ValidateOnly | Out-Null
    if ($null -eq $rollbackJournal -and $null -eq $applyJournal) {
        Set-JsonAtomic $rollbackJournalPath ([ordered]@{ snapshot_id=$SnapshotId; snapshot_sha256=$manifestSha; started_at=(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK') })
    }
    Restore-Snapshot $framework $rollbackRoot -RestoreMetadata -RestoreGit:($null -ne $applyJournal) -VerifyAppliedState
    if (-not (Test-Path -LiteralPath $statePath -PathType Leaf)) {
        $rollbackState = [ordered]@{
            contract_version = 1
            installed_version = [string]$rollbackManifest.from_version
            installed_head = [string]$rollbackManifest.baseline_head
            installed_at = Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'
            last_report_id = $SnapshotId
            rollback_status = 'restored_snapshot_root_git_inactive'
            files = $rollbackManifest.baseline_files
        }
        New-Item -ItemType Directory -Path $stateRoot -Force | Out-Null
        $rollbackState | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $statePath -Encoding utf8
    }
    $rollbackMarkerPath = Join-Path $framework '.project-scaffold.json'
    $rollbackMarker = [ordered]@{}
    if (Test-Path -LiteralPath $rollbackMarkerPath -PathType Leaf) {
        $restoredMarker = Get-Content -Raw -LiteralPath $rollbackMarkerPath | ConvertFrom-Json
        foreach ($property in $restoredMarker.PSObject.Properties) { $rollbackMarker[$property.Name] = $property.Value }
    }
    $rollbackMarker.workspace_type = 'project_scaffold'
    $rollbackMarker.role = 'master_framework'
    $rollbackMarker.updater_contract_version = 1
    $rollbackMarker.installed_version = [string]$rollbackManifest.from_version
    $rollbackMarker.installed_head = [string]$rollbackManifest.baseline_head
    $rollbackMarker.master_head = [string]$rollbackManifest.baseline_head
    $rollbackMarker.update_status = 'rolled_back'
    $rollbackMarker.reconciliation_status = 'blocked_by_framework_rollback_hold'
    $rollbackMarker.git_root_status = 'archived_local_not_a_commit_source'
    $rollbackMarker.git_archive = [string]$rollbackManifest.git_archive
    $rollbackMarker.updater_repository = 'development/_framework-updater'
    $rollbackMarker.master_scaffold_update_source = 'development/_framework-updater'
    Set-JsonAtomic $rollbackMarkerPath $rollbackMarker 6
    if (Test-Path -LiteralPath $rollbackJournalPath -PathType Leaf) { Remove-Item -LiteralPath $rollbackJournalPath -Force }
    if (Test-Path -LiteralPath $applyJournalPath -PathType Leaf) { Remove-Item -LiteralPath $applyJournalPath -Force }
    [ordered]@{
        status = 'rolled_back_root_git_remains_inactive'
        mode = 'rollback'
        snapshot = $rollbackRoot
        target_project_mutation = 'none'
        root_git_reactivated = $false
    } | ConvertTo-Json -Depth 6
    Release-UpdateLock
    exit 0
}
$baselineHashes = @{}
$baselineHead = $null
$baselineMode = $null

if ($null -ne $state) {
    $baselineMode = 'installed_state'
    $baselineHead = [string]$state.installed_head
    if ([string]::IsNullOrWhiteSpace($baselineHead)) { Stop-FrameworkUpdate 'Installed update state has no baseline commit.' }
    $rawBaselineHashes = ConvertTo-HashTable $state.files
    foreach ($pathValue in $rawBaselineHashes.Keys) {
        $safePath = Normalize-RelativePath ([string]$pathValue)
        if ($safePath -ne [string]$pathValue -or (Test-ProtectedPath $safePath)) { Stop-FrameworkUpdate ('Installed state contains an unsafe or protected path: {0}' -f $pathValue) }
        $hashValue = [string]$rawBaselineHashes[$pathValue]
        if ($hashValue -notmatch '^[a-f0-9]{40,64}$') { Stop-FrameworkUpdate ('Installed state contains an invalid file hash: {0}' -f $safePath) }
        $baselineHashes[$safePath] = $hashValue
    }
    & git -C $updater cat-file -e ('{0}^{{commit}}' -f $baselineHead) 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate 'Installed state baseline commit is unavailable in the updater history.' }
    & git -C $updater merge-base --is-ancestor $baselineHead $updaterHead 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate 'Installed state baseline has diverged from the official updater history.' }
    $expectedBaselinePaths = @(Get-TrackedPaths $updater $baselineHead | Sort-Object)
    $recordedBaselinePaths = @($baselineHashes.Keys | Sort-Object)
    if (($expectedBaselinePaths -join "`n") -ne ($recordedBaselinePaths -join "`n")) {
        Stop-FrameworkUpdate 'Installed state file inventory does not match its recorded baseline commit.'
    }
    foreach ($path in $expectedBaselinePaths) {
        if ([string]$baselineHashes[$path] -ne (Get-CommitBlobHash $updater $baselineHead $path)) {
            Stop-FrameworkUpdate ('Installed state hash does not match its recorded baseline commit: {0}' -f $path)
        }
    }
} elseif (Test-Path -LiteralPath (Join-Path $framework '.git')) {
    $baselineMode = 'legacy_root_git'
    $rootGit = Get-GitText $framework @('rev-parse', '--show-toplevel') -Required
    if (-not (Resolve-Directory $rootGit 'Legacy root Git').Equals($framework, [StringComparison]::OrdinalIgnoreCase)) {
        Stop-FrameworkUpdate 'Legacy root Git does not belong to this Master Framework root.'
    }
    $baselineHead = Get-GitText $framework @('rev-parse', 'HEAD') -Required
    & git -C $updater cat-file -e ('{0}^{{commit}}' -f $baselineHead) 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate 'Legacy baseline commit is unavailable in the updater history.' }
    & git -C $updater merge-base --is-ancestor $baselineHead $updaterHead 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate 'Legacy baseline has diverged from the official updater history.' }
    foreach ($path in (Get-TrackedPaths $updater $baselineHead)) {
        $baselineHashes[$path] = Get-CommitBlobHash $updater $baselineHead $path
    }
} elseif ($null -ne $existingMarker -and -not [string]::IsNullOrWhiteSpace([string]$existingMarker.git_archive)) {
    Assert-SafeArchiveName ([string]$existingMarker.git_archive)
    $baselineMode = 'legacy_archived_root_git'
    $legacyArchive = Join-Path $framework ([string]$existingMarker.git_archive)
    if (-not (Test-Path -LiteralPath $legacyArchive -PathType Container)) { Stop-FrameworkUpdate 'Legacy Git archive named by the marker is missing.' }
    $baselineHead = Get-GitDirText $legacyArchive @('rev-parse', 'HEAD') -Required
    & git -C $updater cat-file -e ('{0}^{{commit}}' -f $baselineHead) 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate 'Archived legacy baseline commit is unavailable in the updater history.' }
    & git -C $updater merge-base --is-ancestor $baselineHead $updaterHead 2>$null
    if ($LASTEXITCODE -ne 0) { Stop-FrameworkUpdate 'Archived legacy baseline has diverged from the official updater history.' }
    foreach ($path in (Get-TrackedPaths $updater $baselineHead)) {
        $baselineHashes[$path] = Get-CommitBlobHash $updater $baselineHead $path
    }
} else {
    Stop-FrameworkUpdate 'No installed update state or legacy root Git baseline is available. Manual recovery is required.'
}

$sourcePaths = @(Get-CurrentSourcePaths $updater)
$sourceHashes = @{}
foreach ($path in $sourcePaths) {
    $sourceFile = Join-Path $updater $path
    if (-not (Test-Path -LiteralPath $sourceFile -PathType Leaf)) { Stop-FrameworkUpdate ('Tracked updater file is unavailable: {0}' -f $path) }
    Assert-NoReparsePoint $updater $path
    $sourceHashes[$path] = Get-FileObjectHash $sourceFile
}
$candidatePaths = @($baselineHashes.Keys + $sourceHashes.Keys | Sort-Object -Unique)
$changes = New-Object System.Collections.Generic.List[object]
$conflicts = New-Object System.Collections.Generic.List[string]
foreach ($path in $candidatePaths) {
    $baselineHash = if ($baselineHashes.ContainsKey($path)) { [string]$baselineHashes[$path] } else { $null }
    $sourceHash = if ($sourceHashes.ContainsKey($path)) { [string]$sourceHashes[$path] } else { $null }
    if ($baselineHash -eq $sourceHash) { continue }
    $destination = Get-SafeDestination $framework $path
    $localHash = Get-FileObjectHash $destination
    if ($localHash -ne $baselineHash) { $conflicts.Add($path); continue }
    $changes.Add([ordered]@{ path = $path; action = $(if ($null -eq $sourceHash) { 'delete' } else { 'write' }); before = $baselineHash; after = $sourceHash })
}
if ($conflicts.Count -gt 0) {
    Stop-FrameworkUpdate ('Local generic conflicts detected; no files were changed: {0}' -f ($conflicts -join ', '))
}

$rootGitAction = if (Test-Path -LiteralPath (Join-Path $framework '.git')) { 'archive_after_success' } else { 'already_inactive' }
$rootGitSignature = if ($rootGitAction -eq 'archive_after_success') {
    Get-ReportHash ((Get-GitText $framework @('rev-parse', 'HEAD') -Required) + "`n" + (Get-GitText $framework @('ls-files', '-s') -Required))
} else { 'inactive' }
$reportStateHash = Get-Sha256 $statePath
$reportMarkerHash = Get-Sha256 $markerPath
$reportMaterial = @(
    $physicalFramework.ToLowerInvariant()
    $physicalUpdater.ToLowerInvariant()
    $updaterHead
    $baselineHead
    $baselineMode
    $frameworkState
    [string]$installedVersion
    [string]$availableVersion
    $rootGitAction
    $rootGitSignature
    ('state_sha256={0}' -f [string]$reportStateHash)
    ('marker_sha256={0}' -f [string]$reportMarkerHash)
    ($changes | ForEach-Object { '{0}:{1}:{2}:{3}' -f $_.path, $_.action, $_.before, $_.after })
) -join "`n"
$computedReportId = Get-ReportHash $reportMaterial
$snapshotId = $computedReportId
$snapshotRoot = Join-Path $stateRoot ('snapshots/{0}' -f $snapshotId)
$result = [ordered]@{
    status = $(if ($changes.Count -eq 0 -and $null -ne $state) { 'up_to_date' } else { 'ready_to_apply' })
    mode = $(if ($Apply) { 'apply' } elseif ($Rollback) { 'rollback' } else { 'dry_run' })
    report_id = $computedReportId
    snapshot_id = $snapshotId
    framework_state = $frameworkState
    physical_framework_root = $physicalFramework
    physical_updater_root = $physicalUpdater
    baseline_mode = $baselineMode
    installed_version = $(if ($null -eq $installedVersion) { 'unversioned' } else { $installedVersion })
    available_version = $availableVersion
    baseline_head = $baselineHead
    updater_head = $updaterHead
    changes = [object[]]$changes
    protected_roots = @('artifacts/', 'plan/', 'dev-doc/', 'development/')
    root_git_action = $rootGitAction
    target_project_mutation = 'none'
    snapshot = $snapshotRoot
}

if (-not $Apply) {
    $result | ConvertTo-Json -Depth 8
    exit 0
}
if ($ReportId -ne $computedReportId) { Stop-FrameworkUpdate ('Apply requires the exact current dry-run report id: {0}' -f $computedReportId) }
if (Test-Path -LiteralPath $snapshotRoot) {
    do {
        $snapshotId = Get-ReportHash ('{0}:{1}:{2}' -f $computedReportId, [DateTime]::UtcNow.Ticks, [Guid]::NewGuid().ToString('N'))
        $snapshotRoot = Join-Path $stateRoot ('snapshots/{0}' -f $snapshotId)
    } while (Test-Path -LiteralPath $snapshotRoot)
    $result.snapshot = $snapshotRoot
    $result.snapshot_id = $snapshotId
}

$snapshotFiles = New-Object System.Collections.Generic.List[object]
$metadataFiles = New-Object System.Collections.Generic.List[object]
$gitArchiveName = if ($null -ne $existingMarker -and -not [string]::IsNullOrWhiteSpace([string]$existingMarker.git_archive)) { [string]$existingMarker.git_archive } else { $null }
if ($null -ne $gitArchiveName) { Assert-SafeArchiveName $gitArchiveName }
$activeGitBeforeApply = Join-Path $framework '.git'
if (Test-Path -LiteralPath $activeGitBeforeApply -PathType Container) {
    $gitArchiveName = '.git.master-framework-archive-{0}-{1}' -f (Get-Date -Format 'yyyyMMddHHmmssfff'), ([Guid]::NewGuid().ToString('N').Substring(0, 8))
    Assert-SafeArchiveName $gitArchiveName
}
New-Item -ItemType Directory -Path (Join-Path $snapshotRoot 'files') -Force | Out-Null
foreach ($change in $changes) {
    $destination = Get-SafeDestination $framework ([string]$change.path)
    $existed = Test-Path -LiteralPath $destination -PathType Leaf
    $snapshotFiles.Add([ordered]@{ path = [string]$change.path; existed = $existed; before = [string]$change.before; after = [string]$change.after })
    if ($existed) {
        $backup = Join-Path $snapshotRoot ('files/{0}' -f ([string]$change.path))
        New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
        Copy-Item -LiteralPath $destination -Destination $backup -Force
    }
}
foreach ($metadataName in @('STATE.json', '.project-scaffold.json')) {
    $metadataSource = if ($metadataName -eq 'STATE.json') { $statePath } else { Join-Path $framework $metadataName }
    $metadataExists = Test-Path -LiteralPath $metadataSource -PathType Leaf
    $metadataFiles.Add([ordered]@{ name = $metadataName; existed = $metadataExists; sha256 = $(if ($metadataExists) { Get-Sha256 $metadataSource } else { $null }) })
    if ($metadataExists) {
        $metadataBackup = Join-Path $snapshotRoot ('metadata/{0}' -f $metadataName)
        New-Item -ItemType Directory -Path (Split-Path -Parent $metadataBackup) -Force | Out-Null
        Copy-Item -LiteralPath $metadataSource -Destination $metadataBackup -Force
    }
}
$legacyIndex = Join-Path $activeGitBeforeApply 'index'
$legacyIndexExists = Test-Path -LiteralPath $legacyIndex -PathType Leaf
if ($legacyIndexExists) {
    $indexBackup = Join-Path $snapshotRoot 'metadata/git-index'
    New-Item -ItemType Directory -Path (Split-Path -Parent $indexBackup) -Force | Out-Null
    Copy-Item -LiteralPath $legacyIndex -Destination $indexBackup -Force
}
$snapshotManifest = [ordered]@{
    snapshot_id = $snapshotId
    created_at = Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'
    from_version = $(if ($null -eq $installedVersion) { 'unversioned' } else { $installedVersion })
    to_version = $availableVersion
    to_head = $updaterHead
    baseline_head = $baselineHead
    baseline_files = [ordered]@{}
    files = [object[]]$snapshotFiles
    local_metadata = [object[]]$metadataFiles
    git_archive = $gitArchiveName
    git_index = [ordered]@{ existed = $legacyIndexExists; sha256 = $(if ($legacyIndexExists) { Get-Sha256 $legacyIndex } else { $null }) }
}
foreach ($path in ($baselineHashes.Keys | Sort-Object)) { $snapshotManifest.baseline_files[$path] = $baselineHashes[$path] }
$snapshotManifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath (Join-Path $snapshotRoot 'SNAPSHOT.json') -Encoding utf8
Restore-Snapshot $framework $snapshotRoot -RestoreMetadata -RestoreGit:$legacyIndexExists -ValidateOnly | Out-Null
$snapshotManifestSha = Get-Sha256 (Join-Path $snapshotRoot 'SNAPSHOT.json')
Set-JsonAtomic $applyJournalPath ([ordered]@{ snapshot_id=$snapshotId; snapshot_sha256=$snapshotManifestSha; started_at=(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK') })

$appliedPaths = New-Object System.Collections.Generic.List[string]
$metadataMutated = $false
$gitMutated = $false
try {
    if ((Get-Sha256 $statePath) -ne $reportStateHash -or (Get-Sha256 $markerPath) -ne $reportMarkerHash) {
        throw 'Framework update metadata changed before apply.'
    }
    $currentRootGitSignature = if (Test-Path -LiteralPath (Join-Path $framework '.git')) {
        Get-ReportHash ((Get-GitText $framework @('rev-parse', 'HEAD') -Required) + "`n" + (Get-GitText $framework @('ls-files', '-s') -Required))
    } else { 'inactive' }
    if ($currentRootGitSignature -ne $rootGitSignature) { throw 'Legacy root Git changed after dry-run; a new report is required.' }
    foreach ($change in $changes) {
        $destination = Get-SafeDestination $framework ([string]$change.path)
        if ((Get-FileObjectHash $destination) -ne (Get-NullableHash $change.before)) { throw ('Concurrent local change detected before apply: {0}' -f $change.path) }
        if ($change.action -eq 'write' -and (Get-FileObjectHash (Join-Path $updater ([string]$change.path))) -ne [string]$change.after) { throw ('Updater source changed after verification: {0}' -f $change.path) }
    }
    foreach ($change in $changes) {
        $destination = Get-SafeDestination $framework ([string]$change.path)
        if ((Get-FileObjectHash $destination) -ne (Get-NullableHash $change.before)) { throw ('Concurrent local change detected during apply: {0}' -f $change.path) }
        if ($change.action -eq 'delete') {
            if (Test-Path -LiteralPath $destination -PathType Leaf) { Remove-Item -LiteralPath $destination -Force }
            $appliedPaths.Add([string]$change.path)
            continue
        }
        $source = Join-Path $updater ([string]$change.path)
        New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
        $temporary = '{0}.framework-update-{1}.tmp' -f $destination, $PID
        Copy-Item -LiteralPath $source -Destination $temporary -Force
        Move-Item -LiteralPath $temporary -Destination $destination -Force
        $appliedPaths.Add([string]$change.path)
    }
    foreach ($change in $changes) {
        $destination = Get-SafeDestination $framework ([string]$change.path)
        $actualHash = Get-FileObjectHash $destination
        if ($actualHash -ne $change.after) { throw ('Post-copy validation failed for {0}' -f $change.path) }
    }
    $newState = [ordered]@{
        contract_version = 1
        installed_version = $availableVersion
        installed_head = $updaterHead
        installed_at = Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK'
        last_report_id = $snapshotId
        files = [ordered]@{}
    }
    foreach ($path in ($sourceHashes.Keys | Sort-Object)) { $newState.files[$path] = $sourceHashes[$path] }
    $activeGit = Join-Path $framework '.git'
    if (Test-Path -LiteralPath $activeGit) {
        if ($rootGitAction -ne 'archive_after_success') { throw 'Legacy root Git appeared after dry-run; a new report is required.' }
        $currentRootGitSignature = Get-ReportHash ((Get-GitText $framework @('rev-parse', 'HEAD') -Required) + "`n" + (Get-GitText $framework @('ls-files', '-s') -Required))
        if ($currentRootGitSignature -ne $rootGitSignature) { throw 'Legacy root Git index changed immediately before archival; a new report is required.' }
        $gitMutated = $true
        $staged = Get-GitText $framework @('diff', '--cached', '--name-only') -Required
        if (-not [string]::IsNullOrWhiteSpace($staged)) {
            & git -C $framework restore --staged -- .
            if ($LASTEXITCODE -ne 0) { throw 'Unable to unstage the legacy Master Framework root.' }
        }
        Move-Item -LiteralPath $activeGit -Destination (Join-Path $framework $gitArchiveName)
    }
    elseif ($rootGitAction -eq 'archive_after_success') { throw 'Legacy root Git disappeared after dry-run; a new report is required.' }
    $marker = [ordered]@{}
    if ($null -ne $existingMarker) {
        foreach ($property in $existingMarker.PSObject.Properties) { $marker[$property.Name] = $property.Value }
    }
    $marker.workspace_type = 'project_scaffold'
    $marker.role = 'master_framework'
    $marker.updater_contract_version = 1
    $marker.installed_version = $availableVersion
    $marker.installed_head = $updaterHead
    $marker.update_status = 'completed'
    $marker.git_root_status = 'archived_local_not_a_commit_source'
    $marker.root_index_status = 'fully_unstaged_before_archive'
    $marker.git_archive = $gitArchiveName
    $marker.updater_repository = 'development/_framework-updater'
    $marker.master_scaffold_update_source = 'development/_framework-updater'
    $marker.master_head = $updaterHead
    $marker.reconciliation_status = 'framework_update_applied'
    if ((Get-Sha256 $statePath) -ne $reportStateHash -or (Get-Sha256 $markerPath) -ne $reportMarkerHash) {
        throw 'Framework update metadata changed before final installation metadata write.'
    }
    $metadataMutated = $true
    Set-JsonAtomic $markerPath $marker 6
    $newState.installed_marker_sha256 = Get-Sha256 $markerPath
    $newState.snapshot_sha256 = Get-Sha256 (Join-Path $snapshotRoot 'SNAPSHOT.json')
    New-Item -ItemType Directory -Path $stateRoot -Force | Out-Null
    Set-JsonAtomic $statePath $newState 8
    if (Test-Path -LiteralPath $applyJournalPath -PathType Leaf) { Remove-Item -LiteralPath $applyJournalPath -Force }
} catch {
    Restore-Snapshot $framework $snapshotRoot -RestoreGit:$gitMutated -RestoreMetadata:$metadataMutated -VerifyAppliedState
    if (Test-Path -LiteralPath $applyJournalPath -PathType Leaf) { Remove-Item -LiteralPath $applyJournalPath -Force }
    throw
}

$result.status = 'applied'
$result.root_git_action = $(if ($null -eq $gitArchiveName) { 'already_inactive' } else { 'archived_after_success' })
$result.git_archive = $gitArchiveName
$result | ConvertTo-Json -Depth 8
Release-UpdateLock
