# 🚀 Complete CI/CD Setup Guide

This guide will help you set up a complete CI/CD pipeline with Jenkins, AWS EC2, and GitHub.

## 📋 Prerequisites

- AWS Account with EC2 access
- GitHub repository: `https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git`
- SSH key pair for EC2 access
- Basic knowledge of Jenkins, AWS, and Git

---

## 🏗️ Step 1: Launch and Configure AWS EC2 Instance

### 1.1 Launch EC2 Instance

1. **Go to AWS Console** → EC2 → Launch Instance
2. **Choose AMI**: Ubuntu 22.04 LTS (Free Tier eligible)
3. **Instance Type**: t2.micro or t3.micro (Free Tier)
4. **Key Pair**: Create or select an existing key pair (save the `.pem` file)
5. **Security Group**: 
   - Allow SSH (port 22) from your IP
   - Allow HTTP (port 80) from anywhere (0.0.0.0/0)
   - Allow Custom TCP (port 8080) for Jenkins from your IP
6. **Launch Instance**

### 1.2 Connect to EC2 Instance

```bash
# Replace with your key file and instance IP
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
```

### 1.3 Install Jenkins and Dependencies on EC2

Once connected to EC2, run:

```bash
# Update system
sudo apt-get update

# Install Java (required for Jenkins)
sudo apt-get install -y openjdk-17-jdk

# Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

# Install other dependencies
sudo bash /path/to/scripts/setup_services.sh

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get Jenkins initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

**Save the Jenkins admin password!**

### 1.4 Configure EC2 Security Group

Add inbound rule:
- **Type**: Custom TCP
- **Port**: 8080
- **Source**: Your IP or 0.0.0.0/0 (for testing, restrict later)

---

## 🔧 Step 2: Configure Jenkins

### 2.1 Access Jenkins

1. Open browser: `http://YOUR_EC2_IP:8080`
2. Enter the initial admin password (from Step 1.3)
3. Install suggested plugins
4. Create admin user

### 2.2 Install Required Jenkins Plugins

Go to **Manage Jenkins** → **Plugins** → **Available** and install:

- ✅ **Git Plugin** (usually pre-installed)
- ✅ **SSH Agent Plugin**
- ✅ **GitHub Plugin**
- ✅ **Pipeline Plugin** (usually pre-installed)
- ✅ **Blue Ocean** (optional, for better UI)

### 2.3 Configure Jenkins Credentials

Go to **Manage Jenkins** → **Credentials** → **System** → **Global credentials** → **Add Credentials**

#### A. GitHub Credentials (for HTTPS)

1. **Kind**: Username with password
2. **Scope**: Global
3. **Username**: Your GitHub username
4. **Password**: Your GitHub Personal Access Token (PAT)
   - Create PAT: GitHub → Settings → Developer settings → Personal access tokens → Generate new token
   - Scopes needed: `repo`, `admin:repo_hook`
5. **ID**: `GITHUB_HTTPS_CRED`
6. **Description**: GitHub HTTPS Credentials

#### B. SSH Credentials (for EC2 deployment)

1. **Kind**: SSH Username with private key
2. **Scope**: Global
3. **Username**: `ubuntu`
4. **Private Key**: 
   - Select "Enter directly"
   - Paste the content of your EC2 `.pem` key file
   - Or use "From the Jenkins master ~/.ssh"
5. **ID**: `EC2_PEM_KEY`
6. **Description**: EC2 SSH Key

---

## 🔗 Step 3: Configure GitHub Webhook

### 3.1 Get Jenkins Webhook URL

Your Jenkins webhook URL will be:
```
http://YOUR_EC2_IP:8080/github-webhook/
```

**Note**: For production, use a domain name with SSL. For testing, you can use ngrok or similar.

### 3.2 Configure GitHub Webhook

1. Go to your GitHub repository
2. **Settings** → **Webhooks** → **Add webhook**
3. **Payload URL**: `http://YOUR_EC2_IP:8080/github-webhook/`
4. **Content type**: `application/json`
5. **Events**: Select "Just the push event" or "Let me select individual events"
   - ✅ Pushes
   - ✅ Pull requests (optional)
6. **Active**: ✅
7. **Add webhook**

### 3.3 (Optional) Use ngrok for Local/Testing

If your EC2 doesn't have a public domain:

```bash
# On your local machine or EC2
ngrok http 8080

# Use the ngrok URL in GitHub webhook
# Example: https://abc123.ngrok.io/github-webhook/
```

---

## 🎯 Step 4: Create Jenkins Pipeline

### 4.1 Create New Pipeline Job

1. **Jenkins Dashboard** → **New Item**
2. **Name**: `JOVAC-CICD-Pipeline`
3. **Type**: Pipeline
4. **OK**

### 4.2 Configure Pipeline

1. **Description**: "CI/CD Pipeline for Service-A and Service-B"
2. **Pipeline Definition**: 
   - Select "Pipeline script from SCM"
   - **SCM**: Git
   - **Repository URL**: `https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git`
   - **Credentials**: Select `GITHUB_HTTPS_CRED`
   - **Branches to build**: `*/main`
   - **Script Path**: `Jenkinsfile`
3. **Save**

### 4.3 Update Jenkinsfile with Your EC2 IP

Edit the `Jenkinsfile` in your repository and update:

```groovy
environment {
    EC2_HOST = 'YOUR_EC2_IP'  // Replace with your actual EC2 IP
    SSH_CREDENTIALS_ID = 'EC2_PEM_KEY'
    GITHUB_CREDENTIALS_ID = 'GITHUB_HTTPS_CRED'
    REPO_URL = 'https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
}
```

---

## 🚀 Step 5: Test the Pipeline

### 5.1 Manual Trigger

1. Go to your Jenkins pipeline job
2. Click **Build Now**
3. Watch the build progress in **Console Output**

### 5.2 Automatic Trigger (via GitHub Webhook)

1. Make a change to your repository
2. Commit and push:
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
3. Jenkins should automatically trigger a build

### 5.3 Verify Deployment

SSH into your EC2 instance and check:

```bash
# Check if services are running
sudo systemctl status service-a
sudo systemctl status service-b

# Check service logs
sudo journalctl -u service-a -f
sudo journalctl -u service-b -f

# Test endpoints (if configured)
curl http://localhost:3000  # service-a (adjust port as needed)
curl http://localhost:5000  # service-b (adjust port as needed)
```

---

## 🔍 Troubleshooting

### Jenkins can't connect to GitHub

- Verify GitHub credentials in Jenkins
- Check if Personal Access Token has correct scopes
- Verify repository URL is correct

### Jenkins can't SSH to EC2

- Verify SSH credentials in Jenkins
- Check EC2 security group allows SSH from Jenkins IP
- Test SSH manually: `ssh -i key.pem ubuntu@EC2_IP`

### Deployment fails

- Check Jenkins console output for errors
- Verify EC2 has required packages (nodejs, python3, etc.)
- Check systemd service logs: `sudo journalctl -u service-a -n 50`

### Webhook not triggering

- Verify webhook URL is accessible
- Check GitHub webhook delivery logs
- Use ngrok for local testing
- Verify Jenkins GitHub plugin is installed

---

## 📝 Quick Reference Commands

### On EC2 Instance

```bash
# Check Jenkins status
sudo systemctl status jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Check deployed services
sudo systemctl status service-a
sudo systemctl status service-b

# View service logs
sudo journalctl -u service-a -f
sudo journalctl -u service-b -f
```

### Local Testing

```bash
# Deploy locally (WSL)
bash scripts/deploy_app_local.sh service-a
bash scripts/deploy_app_local.sh service-b
```

---

## ✅ Checklist

- [ ] EC2 instance launched and configured
- [ ] Jenkins installed and accessible
- [ ] Required Jenkins plugins installed
- [ ] GitHub credentials configured in Jenkins
- [ ] SSH credentials configured in Jenkins
- [ ] GitHub webhook configured
- [ ] Jenkinsfile updated with correct EC2 IP
- [ ] Pipeline job created in Jenkins
- [ ] Test build successful
- [ ] Services deployed and running on EC2

---

## 🎉 Success!

Your CI/CD pipeline is now set up! Every push to the `main` branch will automatically:
1. Trigger Jenkins build
2. Build both services
3. Deploy to EC2
4. Start services via systemd

Happy deploying! 🚀

