#!/bin/bash
set -e
apt-get update || yum update -y || true
if command -v apt-get >/dev/null 2>&1; then
  apt-get install -y git nodejs npm python3 python3-venv
else
  yum install -y git nodejs npm python3
fi
mkdir -p /opt
useradd -m ec2-user || true
chown ec2-user:ec2-user /opt
cat > /etc/systemd/system/service-a.service <<'UNIT'
[Unit]
Description=service-a
After=network.target
[Service]
Type=simple
User=ec2-user
ExecStart=/usr/bin/node /opt/service-a/service-a/app.js
Restart=on-failure
[Install]
WantedBy=multi-user.target
UNIT
cat > /etc/systemd/system/service-b.service <<'UNIT'
[Unit]
Description=service-b
After=network.target
[Service]
Type=simple
User=ec2-user
ExecStart=/opt/service-b/service-b/.venv/bin/python /opt/service-b/service-b/app.py
Restart=on-failure
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload || true
systemctl enable service-a || true
systemctl enable service-b || true
