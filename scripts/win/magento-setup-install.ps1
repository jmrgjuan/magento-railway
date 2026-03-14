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

function Get-EnvOrFail {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )

    if (-not $env:$Name) {
        throw "ERROR: Environment variable '$Name' is required but not set. Please define it in your .env file."
    }

    return $env:$Name
}

$baseUrl = Get-EnvOrFail -Name 'MAGENTO_BASE_URL'
$backend = Get-EnvOrFail -Name 'MAGENTO_BACKEND_FRONTNAME'
$adminUser = Get-EnvOrFail -Name 'MAGENTO_ADMIN_USER'
$adminPass = Get-EnvOrFail -Name 'MAGENTO_ADMIN_PASSWORD'
$adminEmail = Get-EnvOrFail -Name 'MAGENTO_ADMIN_EMAIL'
$adminFirst = Get-EnvOrFail -Name 'MAGENTO_ADMIN_FIRSTNAME'
$adminLast = Get-EnvOrFail -Name 'MAGENTO_ADMIN_LASTNAME'

$language = Get-EnvOrFail -Name 'MAGENTO_CONFIG_LANGUAGE'
$currency = Get-EnvOrFail -Name 'MAGENTO_CONFIG_CURRENCY'
$timezone = Get-EnvOrFail -Name 'MAGENTO_CONFIG_TIMEZONE'
$useRewrites = Get-EnvOrFail -Name 'MAGENTO_CONFIG_USE_REWRITES'

$dbHost = Get-EnvOrFail -Name 'DB_HOST'
$dbName = Get-EnvOrFail -Name 'DB_NAME'
$dbUser = Get-EnvOrFail -Name 'DB_USER'
$dbPass = Get-EnvOrFail -Name 'DB_PASSWORD'

$opensearchHost = Get-EnvOrFail -Name 'OPENSEARCH_HOST'
$opensearchPort = Get-EnvOrFail -Name 'OPENSEARCH_PORT'
$opensearchIndexPrefix = Get-EnvOrFail -Name 'OPENSEARCH_INDEX_PREFIX'
$opensearchTimeout = Get-EnvOrFail -Name 'OPENSEARCH_TIMEOUT'

Invoke-DC run --rm php bin/magento setup:install `
  --base-url="$baseUrl" `
  --db-host="$dbHost" --db-name="$dbName" --db-user="$dbUser" --db-password="$dbPass" `
  --backend-frontname="$backend" `
  --admin-firstname="$adminFirst" --admin-lastname="$adminLast" `
  --admin-email="$adminEmail" `
  --admin-user="$adminUser" --admin-password="$adminPass" `
  --language="$language" --currency="$currency" --timezone="$timezone" --use-rewrites="$useRewrites" `
  --search-engine=opensearch `
  --opensearch-host="$opensearchHost" `
  --opensearch-port="$opensearchPort" `
  --opensearch-index-prefix="$opensearchIndexPrefix" `
  --opensearch-timeout="$opensearchTimeout"
