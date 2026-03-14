<#
.SYNOPSIS
  Bootstrap a Magento project using Composer.

.DESCRIPTION
  Requires MAGENTO_PUBLIC_KEY and MAGENTO_PRIVATE_KEY in the .env file.
#>

. "$PSScriptRoot/load-env-variables.ps1"

if (-not $env:MAGENTO_PUBLIC_KEY -or -not $env:MAGENTO_PRIVATE_KEY) {
    throw "ERROR: MAGENTO_PUBLIC_KEY and MAGENTO_PRIVATE_KEY must be set in .env."
}

$edition = if ($env:MAGENTO_EDITION) { $env:MAGENTO_EDITION } else { 'community' }
$version = if ($env:MAGENTO_VERSION) { $env:MAGENTO_VERSION } else { '2.4.7' }

# Configure composer auth
$composerAuthPath = Join-Path $HOME ".composer"
if (-not (Test-Path $composerAuthPath)) { New-Item -ItemType Directory -Path $composerAuthPath | Out-Null }

$authJson = @{
    "http-basic" = @{
        "repo.magento.com" = @{
            username = $env:MAGENTO_PUBLIC_KEY
            password = $env:MAGENTO_PRIVATE_KEY
        }
    }
}
$authJson | ConvertTo-Json -Depth 10 | Out-File -FilePath (Join-Path $composerAuthPath 'auth.json') -Encoding utf8

if (-not (Test-Path composer.json)) {
    Write-Host "Creating Magento project (edition=$edition, version=$version)..."
    composer create-project --repository=https://repo.magento.com/ "magento/project-$edition-edition=$version" .
} else {
    Write-Host "composer.json already exists, running composer install..."
    composer install
}

# Fix permissions (best effort)
try {
    icacls . /grant "Users:(OI)(CI)F" /T | Out-Null
} catch {
    # Not critical if permissions fail
}

Write-Host "✅ Magento skeleton is ready."
