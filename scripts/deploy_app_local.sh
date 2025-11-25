#!/bin/bash
set -e

# Local deployment script (for WSL/local testing)
# $1 comes from command line (e.g., "service-a")
SERVICE=${1:-}
REPO_URL=${REPO_URL:-"https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git"}

if [ -z "$SERVICE" ]; then
  echo "❌ Error: Usage: $0 <service-name>"
  exit 1
fi

# Use current user's home directory
CURRENT_USER=${USER:-$(whoami)}
BASE_DIR="$HOME/deployments"
WORKDIR="$BASE_DIR/$SERVICE"

echo "🚀 Deploying $SERVICE to $WORKDIR..."

# 1. Prepare Directory & Git
mkdir -p "$BASE_DIR"

if [ ! -d "$WORKDIR" ]; then
  echo "🔹 Cloning repo..."
  git clone "$REPO_URL" "$WORKDIR"
fi

cd "$WORKDIR"
echo "🔹 Pulling latest code..."
git fetch --all --prune
git reset --hard origin/main

# Verify the service folder exists inside the repo
if [ ! -d "$WORKDIR/$SERVICE" ]; then
  echo "❌ Error: Expected folder '$SERVICE' not found inside repo!"
  ls -la "$WORKDIR"
  exit 1
fi

# Enter the actual service folder
cd "$WORKDIR/$SERVICE"

# Load .env if exists
if [ -f ".env" ]; then
  echo "🔹 Loading .env file..."
  export $(grep -v '^#' .env | xargs)
fi

# 2. Service Logic
if [ "$SERVICE" = "service-a" ]; then
  echo "📦 Building Node.js Service..."
  npm install
  
  echo "✅ Service-a built successfully!"
  echo "🔹 To run: cd $WORKDIR/$SERVICE && node app.js"

elif [ "$SERVICE" = "service-b" ]; then
  echo "🐍 Building Python Service..."

  # Setup Python Venv
  if [ ! -d ".venv" ]; then
    python3 -m venv .venv
  fi

  source .venv/bin/activate
  pip install --upgrade pip
  
  if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
  fi

  echo "✅ Service-b built successfully!"
  echo "🔹 To run: cd $WORKDIR/$SERVICE && source .venv/bin/activate && python app.py"

else
  echo "❌ Unknown service: $SERVICE"
  exit 2
fi

echo "✅ Deployment of $SERVICE completed successfully."

