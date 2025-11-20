#!/bin/bash
set -e

SERVICE=${1:-}
REPO_URL=${REPO_URL:-"https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git"}

if [ -z "$SERVICE" ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

WORKDIR="/opt/$SERVICE"

# Clone or update repository
if [ ! -d "$WORKDIR" ]; then
  echo "Cloning $REPO_URL into $WORKDIR"
  git clone "$REPO_URL" "$WORKDIR"
fi

cd "$WORKDIR"
git fetch --all --prune
git reset --hard origin/HEAD

if [ ! -d "$WORKDIR/$SERVICE" ]; then
  echo "Expected project layout: repo root must contain $SERVICE folder"
  exit 1
fi

cd "$WORKDIR/$SERVICE"

# Load .env if exists
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

if [ "$SERVICE" = "service-a" ]; then
  echo "Deploying service-a..."
  npm ci

  # Create systemd unit if it does not exist
  if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    cat > /etc/systemd/system/service-a.service <<EOF
[Unit]
Description=service-a Node.js app
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$WORKDIR/$SERVICE
ExecStart=/usr/bin/node $WORKDIR/$SERVICE/app.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable service-a
    systemctl restart service-a || systemctl start service-a
  else
    pkill -f "node .*app.js" || true
    nohup node app.js > /var/log/service-a.log 2>&1 &
  fi

elif [ "$SERVICE" = "service-b" ]; then
  echo "Deploying service-b..."

  # Ensure virtual environment
  if [ ! -d ".venv" ]; then
    python3 -m venv .venv
  fi

  # Activate venv
  source .venv/bin/activate

  pip install --upgrade pip
  if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
  else
    echo "Warning: requirements.txt not found, skipping pip install"
  fi

  # Create systemd unit if it does not exist
  if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    cat > /etc/systemd/system/service-b.service <<EOF
[Unit]
Description=service-b Python app
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=$WORKDIR/$SERVICE
ExecStart=$WORKDIR/$SERVICE/.venv/bin/python $WORKDIR/$SERVICE/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable service-b
    systemctl restart service-b || systemctl start service-b
  else
    pkill -f "python .*app.py" || true
    nohup .venv/bin/python app.py > /var/log/service-b.log 2>&1 &
  fi

else
  echo "Unknown service: $SERVICE"
  exit 2
fi

echo "Deployment of $SERVICE completed."
