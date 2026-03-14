#!/usr/bin/env bash

set -euo pipefail

echo "🛑 Stopping Magento Docker stack..."
docker compose down

echo "✅ Containers stopped."
