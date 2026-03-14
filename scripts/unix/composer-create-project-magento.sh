#!/usr/bin/env bash

set -euo pipefail

echo "✅ Creating Magento project skeleton"

# Load environment variables from .env (required for running scripts)
source "$(dirname "${BASH_SOURCE[0]}")/load-env-variables.sh"

# Ensure the docker stack is running (some actions assume containers are available)
source "$(dirname "${BASH_SOURCE[0]}")/check-running.sh"

# This script bootstraps a Magento project in the current directory.
# It expects the following environment variables to be set:
#   MAGENTO_PUBLIC_KEY, MAGENTO_PRIVATE_KEY, MAGENTO_EDITION, MAGENTO_VERSION
# It will generate ~/.composer/auth.json for Composer and run create-project.

if [[ -z "${MAGENTO_PUBLIC_KEY:-}" || -z "${MAGENTO_PRIVATE_KEY:-}" ]]; then
  echo "ERROR: Please set MAGENTO_PUBLIC_KEY and MAGENTO_PRIVATE_KEY environment variables."
  echo "You can store them in a .env file and load it with 'source .env' or 'export'."
  exit 1
fi

MAGENTO_EDITION=${MAGENTO_EDITION:-community}
MAGENTO_VERSION=${MAGENTO_VERSION:-2.4.7}

# Configure composer auth for Magento repo
mkdir -p "${HOME}/.composer"
cat > "${HOME}/.composer/auth.json" <<'EOF'
{
  "http-basic": {
    "repo.magento.com": {
      "username": "${MAGENTO_PUBLIC_KEY}",
      "password": "${MAGENTO_PRIVATE_KEY}"
    }
  }
}
EOF

if [[ ! -f composer.json ]]; then
  echo "Creating Magento project (edition=${MAGENTO_EDITION}, version=${MAGENTO_VERSION})..."
  composer create-project --repository=https://repo.magento.com/ \
    magento/project-${MAGENTO_EDITION}-edition="${MAGENTO_VERSION}" .
else
  echo "composer.json already exists, running composer install..."
  composer install
fi

# Fix permissions (good for local dev)
chown -R www-data:www-data .
chmod -R g+rw var pub generated

cat <<'EOF'

✅ Magento skeleton is ready.

Next steps (local dev):
  1) Configure env vars (see .env.example)
  2) Run docker compose up -d
  3) Run the Magento install command (example):
     docker compose run --rm php bin/magento setup:install \
       --base-url=${MAGENTO_BASE_URL:-http://localhost:8080/} \
       --db-host=${DB_HOST:-db} --db-name=${DB_NAME:-magento} --db-user=${DB_USER:-magento} --db-password=${DB_PASSWORD:-magento} \
       --backend-frontname=${MAGENTO_BACKEND_FRONTNAME:-admin} \
       --admin-firstname=${MAGENTO_ADMIN_FIRSTNAME:-Admin} --admin-lastname=${MAGENTO_ADMIN_LASTNAME:-User} \
       --admin-email=${MAGENTO_ADMIN_EMAIL:-admin@example.com} \
       --admin-user=${MAGENTO_ADMIN_USER:-admin} --admin-password=${MAGENTO_ADMIN_PASSWORD:-Admin123!} \
       --language=en_US --currency=USD --timezone=America/Chicago --use-rewrites=1

EOF
