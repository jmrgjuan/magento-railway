#!/usr/bin/env bash

set -euo pipefail

# Loads environment variables from the repo root's .env file.
# Exits with an error if the file doesn't exist.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "${REPO_ROOT}/.env" ]]; then
  # shellcheck source=/dev/null
  source "${REPO_ROOT}/.env"
else
  echo "ERROR: .env file not found. Copy .env.example to .env and configure it."
  exit 1
fi
