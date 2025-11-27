#!/bin/bash
# Jenkins Configuration Helper
# This helps configure Jenkins credentials via CLI

set -e

echo "🔧 Jenkins Configuration Helper"
echo "==============================="
echo ""

read -p "Enter Jenkins URL (default: http://13.54.221.81:8080): " JENKINS_URL
JENKINS_URL=${JENKINS_URL:-http://13.54.221.81:8080}

read -p "Enter Jenkins username (default: admin): " JENKINS_USER
JENKINS_USER=${JENKINS_USER:-admin}

read -s -p "Enter Jenkins password: " JENKINS_PASSWORD
echo ""

read -p "Enter path to EC2 .pem key file: " PEM_KEY_PATH

if [ ! -f "$PEM_KEY_PATH" ]; then
    echo "❌ Key file not found: $PEM_KEY_PATH"
    exit 1
fi

echo ""
echo "📥 Downloading Jenkins CLI..."
wget -q "$JENKINS_URL/jnlpJars/jenkins-cli.jar" || {
    echo "❌ Failed to download jenkins-cli.jar"
    exit 1
}

echo "✅ Jenkins CLI downloaded"
echo ""

echo "📝 To add credentials, you need to:"
echo "1. Go to Jenkins UI: $JENKINS_URL"
echo "2. Manage Jenkins → Credentials → System → Global credentials"
echo ""
echo "Add GitHub Credentials:"
echo "  - Kind: Username with password"
echo "  - ID: GITHUB_HTTPS_CRED"
echo "  - Username: Your GitHub username"
echo "  - Password: GitHub Personal Access Token"
echo ""
echo "Add SSH Credentials:"
echo "  - Kind: SSH Username with private key"
echo "  - ID: EC2_PEM_KEY"
echo "  - Username: ubuntu"
echo "  - Private Key: $(cat $PEM_KEY_PATH)"
echo ""

read -p "Press Enter after configuring credentials in Jenkins UI..."

echo ""
echo "✅ Configuration complete!"
echo ""
echo "Next: Create a new Pipeline job in Jenkins using the Jenkinsfile"








