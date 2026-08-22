[CmdletBinding()]
param()

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $PSScriptRoot 'validate-documentation-sync.ps1'
& $validator -RepositoryRoot $repositoryRoot
if ($LASTEXITCODE -eq 0) {
    '{"decision":"allow"}'
    exit 0
}

'{"decision":"continue","reason":"Documentation closure is incomplete. Update the required operational and QA artifacts before claiming completion."}'
exit 0
