<#
.SYNOPSIS
  Load environment variables from the repo's .env file into the current session.

.DESCRIPTION
  This script reads the .env located at the repo root and sets the corresponding
  environment variables for the current PowerShell session.
#>

$RepoRoot = Resolve-Path -Path (Join-Path $PSScriptRoot '..\..')
$EnvFile = Join-Path $RepoRoot '.env'

if (-not (Test-Path $EnvFile)) {
    throw "ERROR: .env file not found. Copy .env.example to .env and configure it."
}

Get-Content $EnvFile | ForEach-Object {
    $line = $_.Trim()
    if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) {
        return
    }

    if ($line -match '^(?<key>[^=]+)=(?<value>.*)$') {
        $key = $Matches['key'].Trim()
        $value = $Matches['value'].Trim().Trim('"')
        Set-Item -Path Env:$key -Value $value
    }
}
