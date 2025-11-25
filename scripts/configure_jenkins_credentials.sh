#!/bin/bash
# Jenkins Credentials Configuration Helper Script
# This script provides instructions and can help configure Jenkins via CLI

set -e

JENKINS_URL=${JENKINS_URL:-"http://localhost:8080"}
JENKINS_USER=${JENKINS_USER:-"admin"}
JENKINS_PASSWORD=${JENKINS_PASSWORD:-""}

echo "🔧 Jenkins Credentials Configuration Helper"
echo "==========================================="
echo ""

if [ -z "$JENKINS_PASSWORD" ]; then
  echo "⚠️  JENKINS_PASSWORD not set. Please set it or run this script with:"
  echo "   JENKINS_PASSWORD=your_password bash $0"
  echo ""
  echo "📝 Manual Configuration Steps:"
  echo ""
  echo "1. Go to Jenkins → Manage Jenkins → Credentials → System → Global credentials"
  echo ""
  echo "2. Add GitHub Credentials:"
  echo "   - Kind: Username with password"
  echo "   - Username: Your GitHub username"
  echo "   - Password: Your GitHub Personal Access Token"
  echo "   - ID: GITHUB_HTTPS_CRED"
  echo "   - Description: GitHub HTTPS Credentials"
  echo ""
  echo "3. Add SSH Credentials:"
  echo "   - Kind: SSH Username with private key"
  echo "   - Username: ubuntu"
  echo "   - Private Key: Enter directly (paste your EC2 .pem key content)"
  echo "   - ID: EC2_PEM_KEY"
  echo "   - Description: EC2 SSH Key"
  echo ""
  exit 0
fi

echo "🔐 Configuring Jenkins credentials..."
echo "Jenkins URL: $JENKINS_URL"
echo ""

# Check if jenkins-cli.jar exists
if [ ! -f "jenkins-cli.jar" ]; then
  echo "📥 Downloading Jenkins CLI..."
  wget "$JENKINS_URL/jnlpJars/jenkins-cli.jar" || {
    echo "❌ Failed to download jenkins-cli.jar"
    echo "Please download manually from: $JENKINS_URL/jnlpJars/jenkins-cli.jar"
    exit 1
  }
fi

echo "✅ Jenkins CLI downloaded"
echo ""
echo "📝 To configure credentials via CLI, use:"
echo ""
echo "java -jar jenkins-cli.jar -s $JENKINS_URL -auth $JENKINS_USER:$JENKINS_PASSWORD create-credentials-by-xml system::system::jenkins _ < credentials.xml"
echo ""
echo "For more information, see: CI_CD_SETUP_GUIDE.md"

