#!/usr/bin/env bash

set -euo pipefail

# Load a cross-platform docker compose helper (supports "docker compose" and "docker-compose").
source "$(dirname "${BASH_SOURCE[0]}")/docker-compose-helper.sh"

echo "🚀 Starting Magento Docker stack..."
dc up -d

echo "✅ Containers are up. Check status with ./scripts/status.sh"
