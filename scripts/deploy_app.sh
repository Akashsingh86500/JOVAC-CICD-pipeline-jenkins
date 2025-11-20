#!/bin/bash
set -euo pipefail

SERVICE=${1:-}
REPO_URL=${REPO_URL:-${2:-}}

if [ -z "$SERVICE" ]; then
  echo "Usage: $0 <service-name> [repo-url]" >&2
  exit 1
fi

if [ -z "$REPO_URL" ]; then
  echo "REPO_URL not provided. Set the REPO_URL environment variable or pass it as second argument." >&2
  exit 1
fi

WORKDIR="/opt/$SERVICE"

if [ ! -d "$WORKDIR" ]; then
  echo "Cloning $REPO_URL into $WORKDIR"
  git clone "$REPO_URL" "$WORKDIR"
fi

cd "$WORKDIR"
git fetch --all --prune
git reset --hard origin/HEAD

if [ ! -d "$WORKDIR/$SERVICE" ]; then
  echo "Expected project layout: repository root contains $SERVICE directory" >&2
  exit 1
fi

cd "$WORKDIR/$SERVICE"

if [ "$SERVICE" = "service-a" ]; then
  echo "Installing service-a dependencies and restarting"
  npm ci
  if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    systemctl daemon-reload || true
    systemctl restart service-a || systemctl start service-a || true
  else
    pkill -f "node .*${SERVICE}/app.js" || true
    nohup node app.js > /var/log/${SERVICE}.log 2>&1 &
  fi
elif [ "$SERVICE" = "service-b" ]; then
  echo "Installing service-b dependencies and restarting"
  python3 -m venv .venv || true
  . .venv/bin/activate
  pip install -r requirements.txt
  if command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; then
    systemctl daemon-reload || true
    systemctl restart service-b || systemctl start service-b || true
  else
    pkill -f "python .*${SERVICE}/app.py" || true
    nohup .venv/bin/python app.py > /var/log/${SERVICE}.log 2>&1 &
  fi
else
  echo "Unknown service: $SERVICE" >&2
  exit 2
fi

echo "Deployment of $SERVICE completed."
