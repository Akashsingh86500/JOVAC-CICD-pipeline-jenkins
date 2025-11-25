#!/bin/bash
set -e

# Jenkins Setup Script for EC2 Ubuntu Instance
# Run this script on your EC2 instance after launching it

echo "🚀 Setting up Jenkins and dependencies on EC2..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "⚠️  This script requires sudo. Running with sudo..."
  exec sudo bash "$0" "$@"
fi

# Update system
echo "📦 Updating system packages..."
apt-get update -y

# Install Java (required for Jenkins)
echo "☕ Installing Java 17..."
apt-get install -y openjdk-17-jdk

# Verify Java installation
java -version

# Install Jenkins
echo "🔧 Installing Jenkins..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update
apt-get install -y jenkins

# Install other dependencies
echo "📦 Installing Node.js, Python, and Git..."
apt-get install -y git python3 python3-venv python3-pip nodejs npm

# Enable npm via corepack if needed
if ! command -v npm >/dev/null 2>&1; then
  corepack enable npm || true
fi

# Start and enable Jenkins
echo "🔄 Starting Jenkins..."
systemctl start jenkins
systemctl enable jenkins

# Wait for Jenkins to start
sleep 10

# Display Jenkins initial admin password
echo ""
echo "=========================================="
echo "✅ Jenkins installed successfully!"
echo "=========================================="
echo ""
echo "📝 Jenkins Initial Admin Password:"
echo "-----------------------------------"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""
echo "-----------------------------------"
echo ""
echo "🌐 Access Jenkins at: http://$(curl -s ifconfig.me || hostname -I | awk '{print $1}'):8080"
echo ""
echo "📋 Next Steps:"
echo "1. Open Jenkins in your browser"
echo "2. Enter the admin password above"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Configure credentials (GitHub and SSH)"
echo ""

# Create deployment directory
echo "📁 Creating deployment directory..."
mkdir -p /home/ubuntu/deployments
chown ubuntu:ubuntu /home/ubuntu/deployments

echo "✅ Setup complete!"

