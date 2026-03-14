<#
.SYNOPSIS
  Run Magento setup:install inside the PHP container.
#>

. "$PSScriptRoot/load-env-variables.ps1"
. "$PSScriptRoot/docker-compose-helper.ps1"

# Ensure the stack is running (basic check)
Invoke-DC ps php > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "ERROR: Docker compose project is not running. Run .\start.ps1 first."
}

$baseUrl = if ($env:MAGENTO_BASE_URL) { $env:MAGENTO_BASE_URL } else { 'http://localhost:8080/' }
$backend = if ($env:MAGENTO_BACKEND_FRONTNAME) { $env:MAGENTO_BACKEND_FRONTNAME } else { 'admin' }
$adminUser = if ($env:MAGENTO_ADMIN_USER) { $env:MAGENTO_ADMIN_USER } else { 'admin' }
$adminPass = if ($env:MAGENTO_ADMIN_PASSWORD) { $env:MAGENTO_ADMIN_PASSWORD } else { 'Admin123!' }
$adminEmail = if ($env:MAGENTO_ADMIN_EMAIL) { $env:MAGENTO_ADMIN_EMAIL } else { 'admin@example.com' }
$adminFirst = if ($env:MAGENTO_ADMIN_FIRSTNAME) { $env:MAGENTO_ADMIN_FIRSTNAME } else { 'Admin' }
$adminLast = if ($env:MAGENTO_ADMIN_LASTNAME) { $env:MAGENTO_ADMIN_LASTNAME } else { 'User' }

$dbHost = if ($env:DB_HOST) { $env:DB_HOST } else { 'db' }
$dbName = if ($env:DB_NAME) { $env:DB_NAME } else { 'magento' }
$dbUser = if ($env:DB_USER) { $env:DB_USER } else { 'magento' }
$dbPass = if ($env:DB_PASSWORD) { $env:DB_PASSWORD } else { 'magento' }

Invoke-DC run --rm php bin/magento setup:install `
  --base-url=$baseUrl `
  --db-host=$dbHost --db-name=$dbName --db-user=$dbUser --db-password=$dbPass `
  --backend-frontname=$backend `
  --admin-firstname=$adminFirst --admin-lastname=$adminLast `
  --admin-email=$adminEmail `
  --admin-user=$adminUser --admin-password=$adminPass `
  --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
