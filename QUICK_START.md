# 🚀 Quick Start Guide

## For Local Testing (WSL/Linux)

```bash
# Fix line endings and make scripts executable
sed -i 's/\r$//' scripts/*.sh
chmod +x scripts/*.sh

# Deploy locally
bash scripts/deploy_app_local.sh service-a
bash scripts/deploy_app_local.sh service-b
```

## For AWS EC2 + Jenkins CI/CD Setup

### Step 1: Launch EC2 Instance
1. AWS Console → EC2 → Launch Instance
2. Ubuntu 22.04 LTS, t2.micro
3. Configure security group (SSH:22, HTTP:80, Jenkins:8080)
4. Launch and save your `.pem` key

### Step 2: Setup Jenkins on EC2

```bash
# SSH into your EC2 instance
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Upload and run setup script
# (Copy setup_jenkins.sh to EC2 or clone the repo)
git clone https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git
cd JOVAC-CICD-pipeline-jenkins
sudo bash scripts/setup_jenkins.sh
```

**Save the Jenkins admin password shown at the end!**

### Step 3: Configure Jenkins

1. **Access Jenkins**: `http://YOUR_EC2_IP:8080`
2. **Enter admin password** (from Step 2)
3. **Install suggested plugins**
4. **Create admin user**

### Step 4: Add Credentials in Jenkins

Go to **Manage Jenkins** → **Credentials** → **System** → **Global credentials**

#### GitHub Credentials:
- **Kind**: Username with password
- **Username**: Your GitHub username
- **Password**: GitHub Personal Access Token
- **ID**: `GITHUB_HTTPS_CRED`

#### SSH Credentials:
- **Kind**: SSH Username with private key
- **Username**: `ubuntu`
- **Private Key**: Paste your EC2 `.pem` file content
- **ID**: `EC2_PEM_KEY`

### Step 5: Update Jenkinsfile

Edit `Jenkinsfile` and update the EC2 IP:

```groovy
environment {
    EC2_HOST = 'YOUR_EC2_IP'  // Change this!
    ...
}
```

### Step 6: Create Pipeline in Jenkins

1. **New Item** → **Pipeline**
2. **Name**: `JOVAC-CICD-Pipeline`
3. **Pipeline Definition**: Pipeline script from SCM
4. **SCM**: Git
5. **Repository URL**: `https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git`
6. **Credentials**: `GITHUB_HTTPS_CRED`
7. **Branch**: `*/main`
8. **Script Path**: `Jenkinsfile`
9. **Save**

### Step 7: Configure GitHub Webhook

1. GitHub repo → **Settings** → **Webhooks** → **Add webhook**
2. **Payload URL**: `http://YOUR_EC2_IP:8080/github-webhook/`
3. **Content type**: `application/json`
4. **Events**: Just the push event
5. **Add webhook**

### Step 8: Test!

```bash
# Make a change and push
git add .
git commit -m "Test CI/CD"
git push origin main
```

Jenkins will automatically build and deploy! 🎉

---

## 📚 Full Documentation

See `CI_CD_SETUP_GUIDE.md` for detailed instructions and troubleshooting.

