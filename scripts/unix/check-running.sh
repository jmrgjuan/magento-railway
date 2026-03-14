#!/usr/bin/env bash

set -euo pipefail

# Ensure docker compose is initialized and containers are up.
# This is meant to be sourced by other scripts.

source "$(dirname "${BASH_SOURCE[0]}")/docker-compose-helper.sh"

if ! dc ps php >/dev/null 2>&1; then
  echo "ERROR: Docker compose project is not running (php service not found)."
  echo "Run ./scripts/start.sh first."
  exit 1
fi

# If any service is not "Up", treat it as not running.
if ! dc ps | tail -n +3 | grep -q "Up"; then
  echo "ERROR: Some containers are not running."
  dc ps
  echo "Run ./scripts/start.sh and try again."
  exit 1
fi
