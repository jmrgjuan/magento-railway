#!/usr/bin/env bash

set -euo pipefail

# Load environment variables from .env (required for running scripts)
source "$(dirname "${BASH_SOURCE[0]}")/load-env-variables.sh"

# Ensure the compose stack is running before attempting setup.
source "$(dirname "${BASH_SOURCE[0]}")/check-running.sh"

get_env_or_fail() {
  local name="$1"
  local val
  val="${!name:-}"

  if [[ -z "$val" ]]; then
    echo "ERROR: Environment variable '$name' is required but not set. Please define it in .env." >&2
    exit 1
  fi

  printf '%s' "$val"
}

# Required variables
baseUrl=$(get_env_or_fail MAGENTO_BASE_URL)
backend=$(get_env_or_fail MAGENTO_BACKEND_FRONTNAME)
adminUser=$(get_env_or_fail MAGENTO_ADMIN_USER)
adminPass=$(get_env_or_fail MAGENTO_ADMIN_PASSWORD)
adminEmail=$(get_env_or_fail MAGENTO_ADMIN_EMAIL)
adminFirst=$(get_env_or_fail MAGENTO_ADMIN_FIRSTNAME)
adminLast=$(get_env_or_fail MAGENTO_ADMIN_LASTNAME)

language=$(get_env_or_fail MAGENTO_CONFIG_LANGUAGE)
currency=$(get_env_or_fail MAGENTO_CONFIG_CURRENCY)
timezone=$(get_env_or_fail MAGENTO_CONFIG_TIMEZONE)
useRewrites=$(get_env_or_fail MAGENTO_CONFIG_USE_REWRITES)

dbHost=$(get_env_or_fail DB_HOST)
dbName=$(get_env_or_fail DB_NAME)
dbUser=$(get_env_or_fail DB_USER)
dbPass=$(get_env_or_fail DB_PASSWORD)

opensearchHost=$(get_env_or_fail OPENSEARCH_HOST)
opensearchPort=$(get_env_or_fail OPENSEARCH_PORT)
opensearchIndexPrefix=$(get_env_or_fail OPENSEARCH_INDEX_PREFIX)
opensearchTimeout=$(get_env_or_fail OPENSEARCH_TIMEOUT)

docker compose run --rm php bin/magento setup:install \
  --base-url="${baseUrl}" \
  --db-host="${dbHost}" --db-name="${dbName}" --db-user="${dbUser}" --db-password="${dbPass}" \
  --backend-frontname="${backend}" \
  --admin-firstname="${adminFirst}" --admin-lastname="${adminLast}" \
  --admin-email="${adminEmail}" \
  --admin-user="${adminUser}" --admin-password="${adminPass}" \
  --language="${language}" --currency="${currency}" --timezone="${timezone}" --use-rewrites="${useRewrites}" \
  --search-engine=opensearch \
  --opensearch-host="${opensearchHost}" \
  --opensearch-port="${opensearchPort}" \
  --opensearch-index-prefix="${opensearchIndexPrefix}" \
  --opensearch-timeout="${opensearchTimeout}"
