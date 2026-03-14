#!/usr/bin/env bash

set -euo pipefail

# Load environment variables from .env (required for running scripts)
source "$(dirname "${BASH_SOURCE[0]}")/load-env-variables.sh"

# Ensure the compose stack is running before attempting setup.
source "$(dirname "${BASH_SOURCE[0]}")/check-running.sh"

docker compose run --rm php bin/magento setup:install \
  --base-url=${MAGENTO_BASE_URL:-http://localhost:8080/} \
  --db-host=${DB_HOST:-db} --db-name=${DB_NAME:-magento} --db-user=${DB_USER:-magento} --db-password=${DB_PASSWORD:-magento} \
  --backend-frontname=${MAGENTO_BACKEND_FRONTNAME:-admin} \
  --admin-firstname=${MAGENTO_ADMIN_FIRSTNAME:-Admin} --admin-lastname=${MAGENTO_ADMIN_LASTNAME:-User} \
  --admin-email=${MAGENTO_ADMIN_EMAIL:-admin@example.com} \
  --admin-user=${MAGENTO_ADMIN_USER:-admin} --admin-password=${MAGENTO_ADMIN_PASSWORD:-Admin123!} \
  --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1
