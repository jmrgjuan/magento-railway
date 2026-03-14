<#
.SYNOPSIS
  Start the Magento Docker stack.
#>

. "$PSScriptRoot/docker-compose-helper.ps1"

Write-Host "🚀 Starting Magento Docker stack... (building if needed)"
Invoke-DC up -d --build
Write-Host "✅ Containers are up. Check status with .\status.ps1"
