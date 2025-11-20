#!/bin/bash
set -e

# Must run as root
if [ "$EUID" -ne 0 ]; then
  exec sudo bash "$0" "$@"
fi

apt-get update -y
apt-get install -y git nodejs npm python3 python3-venv

mkdir -p /opt
chown ubuntu:ubuntu /opt

# service-a systemd unit
cat > /etc/systemd/system/service-a.service <<EOF
[Unit]
Description=service-a Node.js app
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/service-a/service-a
ExecStart=/usr/bin/node /opt/service-a/service-a/app.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# service-b systemd unit
cat > /etc/systemd/system/service-b.service <<EOF
[Unit]
Description=service-b Python app
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/service-b/service-b
ExecStart=/opt/service-b/service-b/.venv/bin/python /opt/service-b/service-b/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable service-a
systemctl enable service-b
