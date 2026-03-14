<#
.SYNOPSIS
  Stop the Magento Docker stack.
#>

. "$PSScriptRoot/docker-compose-helper.ps1"

Write-Host "🛑 Stopping Magento Docker stack..."
Invoke-DC down
Write-Host "✅ Containers stopped."
