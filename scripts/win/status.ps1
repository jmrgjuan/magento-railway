<#
.SYNOPSIS
  Show Docker Compose status.
#>

. "$PSScriptRoot/docker-compose-helper.ps1"

Write-Host "Docker Compose status:"
Invoke-DC ps
