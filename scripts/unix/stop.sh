#!/usr/bin/env bash

set -euo pipefail

# Load a cross-platform docker compose helper (supports "docker compose" and "docker-compose").
source "$(dirname "${BASH_SOURCE[0]}")/docker-compose-helper.sh"

echo "🛑 Stopping Magento Docker stack..."
dc down

echo "✅ Containers stopped."
