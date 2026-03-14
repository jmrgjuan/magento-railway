<#
.SYNOPSIS
  Start the Magento Docker stack.
#>

. "$PSScriptRoot/docker-compose-helper.ps1"

Write-Host "🚀 Starting Magento Docker stack..."
Invoke-DC up -d
Write-Host "✅ Containers are up. Check status with .\status.ps1"
