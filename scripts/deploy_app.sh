#!/bin/bash
set -e

SERVICE=$1

# Correct SSH repo URL for Jenkins + EC2 deployments
REPO_URL="${REPO_URL:-git@github.com:Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git}"

# Deployment directory
WORKDIR="/opt/$SERVICE"

if [ -z "$SERVICE" ]; then
  echo "ERROR: No service name provided"
  exit 1
fi

# If first time, clone repo
if [ ! -d "$WORKDIR" ]; then
  git clone "$REPO_URL" "$WORKDIR"
fi

cd "$WORKDIR"
git fetch origin
git reset --hard origin/main

cd "$WORKDIR/$SERVICE"

if [ "$SERVICE" = "service-a" ]; then
  echo "Installing Node modules..."
  npm ci

  echo "Restarting service-a..."
  sudo systemctl daemon-reload
  sudo systemctl restart service-a || sudo systemctl start service-a

elif [ "$SERVICE" = "service-b" ]; then
  echo "Creating Python virtual environment..."
  python3 -m venv .venv || true
  source .venv/bin/activate

  pip install --upgrade pip
  pip install -r requirements.txt

  echo "Restarting service-b..."
  sudo systemctl daemon-reload
  sudo systemctl restart service-b || sudo systemctl start service-b
fi
