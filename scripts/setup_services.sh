#!/bin/bash
set -e

# Must run as root
if [ "$EUID" -ne 0 ]; then
  echo "Running with sudo..."
  exec sudo bash "$0" "$@"
fi

echo "Updating system packages..."
apt-get update -y

echo "Installing required packages..."
apt-get install -y git python3 python3-venv python3-pip nodejs npm

# Ensure corepack for npm is enabled
if ! command -v npm >/dev/null 2>&1; then
  corepack enable npm || true
fi

# Create /opt directory for deployments
mkdir -p /opt
chown ubuntu:ubuntu /opt

echo "System setup complete."
