param()
$ErrorActionPreference = "Stop"
$root = (git rev-parse --show-toplevel).Trim()
if (-not $root) { throw "Run this script from inside a Git repository." }
if ($root -match '[\\/]development[\\/]') { throw "Target projects must use their own repository." }
$remote = (git -C $root config --get remote.origin.url 2>$null).Trim()
$normalizedRemote = $remote.TrimEnd('/')
if ($normalizedRemote.EndsWith('.git')) { $normalizedRemote = $normalizedRemote.Substring(0, $normalizedRemote.Length - 4) }
$allowed = @("https://github.com/odonplay/odonplay-agent-scaffold", "git@github.com:odonplay/odonplay-agent-scaffold", "ssh://git@github.com/odonplay/odonplay-agent-scaffold")
if ($allowed -notcontains $normalizedRemote) { throw "Scaffold maintenance requires the official odonplay-agent-scaffold origin. Actual: $remote" }
