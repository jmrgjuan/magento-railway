<#
.SYNOPSIS
  Start the Magento Docker stack.
#>

. "$PSScriptRoot/docker-compose-helper.ps1"

Write-Host "-- Starting Magento Docker stack... (building if needed)"

# Run compose in the background so the script can exit immediately.
# Use Start-Process to detach; output can be monitored with `docker compose logs -f`.
Start-Process -FilePath docker -ArgumentList 'compose','up','-d','--build'

Write-Host "-- Command dispatched. Check status with .\status.ps1 or view logs with `docker compose logs -f`"
