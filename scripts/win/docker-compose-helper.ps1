<#
.SYNOPSIS
  Cross-platform docker compose helper for PowerShell.

.DESCRIPTION
  Detects whether to use `docker compose` (modern) or `docker-compose` (legacy) and exposes a helper function `Invoke-DC`.
#>

function Get-DCCommand {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        try {
            docker compose version >$null 2>$null
            return @('docker', 'compose')
        } catch {
            # ignore
        }
    }

    if (Get-Command docker-compose -ErrorAction SilentlyContinue) {
        return @('docker-compose')
    }

    throw 'ERROR: Cannot find Docker Compose. Install Docker Desktop or docker-compose and ensure it is on your PATH.'
}

function Invoke-DC {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    $cmd = Get-DCCommand
    & $cmd[0] @($cmd[1..($cmd.Length-1)] + $Args)
}
