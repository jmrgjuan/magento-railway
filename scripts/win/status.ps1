<#
.SYNOPSIS
  Show Docker Compose status.
#>

. "$PSScriptRoot/docker-compose-helper.ps1"

Write-Host "-- Docker Compose status:"
Invoke-DC ps --format "table {{.Name}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
