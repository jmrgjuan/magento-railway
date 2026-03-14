#!/usr/bin/env bash

set -euo pipefail

# Cross-platform helper to locate a working Docker Compose command.
# Supports "docker compose" (modern) or "docker-compose" (legacy).

DOCKER_COMPOSE_CMD=()

if command -v docker >/dev/null 2>&1; then
  if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD=(docker compose)
  fi
fi

if [[ ${#DOCKER_COMPOSE_CMD[@]} -eq 0 ]] && command -v docker-compose >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD=(docker-compose)
fi

if [[ ${#DOCKER_COMPOSE_CMD[@]} -eq 0 ]]; then
  echo "ERROR: Cannot find Docker Compose. Install Docker Desktop or docker-compose and ensure it's on your PATH."
  exit 1
fi

# Call this helper function to run Docker Compose.
# Example: dc up -d
function dc() {
  "${DOCKER_COMPOSE_CMD[@]}" "$@"
}
