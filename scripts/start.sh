#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Starting Magento Docker stack..."
docker compose up -d

echo "✅ Containers are up. Check status with ./scripts/status.sh"
