#!/bin/bash
# Complete CI/CD Setup Script
# Run this to set up Jenkins CI/CD pipeline

set -e

echo "🚀 CI/CD Setup Script"
echo "===================="
echo ""

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first."
    exit 1
fi

echo "📋 Step 1: Get EC2 Instance Information"
echo "----------------------------------------"
read -p "Enter your EC2 instance IP (or press Enter to use 13.54.221.81): " EC2_IP
EC2_IP=${EC2_IP:-13.54.221.81}

read -p "Enter path to your EC2 .pem key file: " PEM_KEY_PATH

if [ ! -f "$PEM_KEY_PATH" ]; then
    echo "❌ Key file not found: $PEM_KEY_PATH"
    exit 1
fi

echo ""
echo "📋 Step 2: Update Jenkinsfile with EC2 IP"
echo "----------------------------------------"
sed -i "s/EC2_HOST = '.*'/EC2_HOST = '$EC2_IP'/" Jenkinsfile
echo "✅ Jenkinsfile updated with EC2 IP: $EC2_IP"

echo ""
echo "📋 Step 3: Upload setup script to EC2"
echo "----------------------------------------"
echo "Uploading setup_jenkins.sh to EC2..."
scp -i "$PEM_KEY_PATH" scripts/setup_jenkins.sh ubuntu@$EC2_IP:/tmp/
scp -i "$PEM_KEY_PATH" scripts/setup_services.sh ubuntu@$EC2_IP:/tmp/
scp -i "$PEM_KEY_PATH" scripts/deploy_app.sh ubuntu@$EC2_IP:/tmp/

echo ""
echo "📋 Step 4: Setup Jenkins on EC2"
echo "----------------------------------------"
echo "Connecting to EC2 and running setup..."
ssh -i "$PEM_KEY_PATH" ubuntu@$EC2_IP "sudo bash /tmp/setup_jenkins.sh"

echo ""
echo "📋 Step 5: Get Jenkins Admin Password"
echo "----------------------------------------"
JENKINS_PASSWORD=$(ssh -i "$PEM_KEY_PATH" ubuntu@$EC2_IP "sudo cat /var/lib/jenkins/secrets/initialAdminPassword")
echo "Jenkins Admin Password: $JENKINS_PASSWORD"
echo ""
echo "Save this password!"

echo ""
echo "✅ Setup Complete!"
echo "=================="
echo ""
echo "Next Steps:"
echo "1. Open Jenkins: http://$EC2_IP:8080"
echo "2. Enter password: $JENKINS_PASSWORD"
echo "3. Install suggested plugins"
echo "4. Create admin user"
echo "5. Add credentials:"
echo "   - GitHub: GITHUB_HTTPS_CRED (username + Personal Access Token)"
echo "   - SSH: EC2_PEM_KEY (username: ubuntu, private key from $PEM_KEY_PATH)"
echo "6. Create pipeline job using Jenkinsfile"
echo "7. Configure GitHub webhook: http://$EC2_IP:8080/github-webhook/"


