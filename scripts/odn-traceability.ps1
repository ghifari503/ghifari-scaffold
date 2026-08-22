[CmdletBinding()]
param(
    [Parameter(Position = 0)] [string]$Command = 'help',
    [Parameter(ValueFromRemainingArguments = $true)] [string[]]$Arguments
)

$ErrorActionPreference = 'Stop'
$script = Join-Path $PSScriptRoot 'odn-traceability.mjs'
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw 'ODN_TRACEABILITY_BLOCKED: Node.js is required.'
}
& node $script $Command @Arguments
exit $LASTEXITCODE
