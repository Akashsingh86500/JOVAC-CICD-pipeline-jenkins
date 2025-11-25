#!/bin/bash
set -e

# $1 comes from Jenkins (e.g., "service-a")
SERVICE=${1:-}
REPO_URL=${REPO_URL:-"https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git"}

if [ -z "$SERVICE" ]; then
  echo "❌ Error: Usage: $0 <service-name>"
  exit 1
fi

# Use home directory to avoid permission issues with Git
# Detect current user (works for both ubuntu on EC2 and other users)
# If DEPLOY_USER is not set, try to detect from environment or default to ubuntu
if [ -z "$DEPLOY_USER" ]; then
  if [ -n "$USER" ]; then
    DEPLOY_USER="$USER"
  elif [ -n "$SUDO_USER" ]; then
    DEPLOY_USER="$SUDO_USER"
  else
    DEPLOY_USER="ubuntu"
  fi
fi
BASE_DIR="/home/$DEPLOY_USER/deployments"
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
git reset --hard origin/main  # Changed from HEAD to origin/main to be safer

# Verify the service folder exists inside the repo
if [ ! -d "$WORKDIR/$SERVICE" ]; then
  echo "❌ Error: Expected folder '$SERVICE' not found inside repo!"
  ls -la "$WORKDIR"
  exit 1
fi

# Enter the actual service folder (e.g., service-a/service-a)
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

  # Create Systemd Service (Requires Sudo)
  echo "🔹 Configuring Systemd for $SERVICE..."
  
  # We use 'sudo tee' to write to protected /etc/ folder
  sudo tee /etc/systemd/system/$SERVICE.service > /dev/null <<EOF
[Unit]
Description=$SERVICE Node.js app
After=network.target

[Service]
Type=simple
User=$DEPLOY_USER
WorkingDirectory=$WORKDIR/$SERVICE
ExecStart=/usr/bin/node $WORKDIR/$SERVICE/app.js
Restart=always
# Environment variables can be added here if needed
# Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

  echo "🔹 Restarting Systemd Service..."
  sudo systemctl daemon-reload
  sudo systemctl enable $SERVICE
  sudo systemctl restart $SERVICE

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

  # Create Systemd Service (Requires Sudo)
  echo "🔹 Configuring Systemd for $SERVICE..."

  sudo tee /etc/systemd/system/$SERVICE.service > /dev/null <<EOF
[Unit]
Description=$SERVICE Python app
After=network.target

[Service]
Type=simple
User=$DEPLOY_USER
WorkingDirectory=$WORKDIR/$SERVICE
ExecStart=$WORKDIR/$SERVICE/.venv/bin/python $WORKDIR/$SERVICE/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

  echo "🔹 Restarting Systemd Service..."
  sudo systemctl daemon-reload
  sudo systemctl enable $SERVICE
  sudo systemctl restart $SERVICE

else
  echo "❌ Unknown service: $SERVICE"
  exit 2
fi

echo "✅ Deployment of $SERVICE completed successfully."
