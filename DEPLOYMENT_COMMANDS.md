# 📝 Deployment Commands Reference

## Local Deployment (WSL/Linux)

### Fix Script Line Endings First
```bash
# Remove Windows line endings
sed -i 's/\r$//' scripts/*.sh

# Make scripts executable
chmod +x scripts/*.sh
```

### Deploy Services Locally
```bash
# Deploy service-a (Node.js)
bash scripts/deploy_app_local.sh service-a

# Deploy service-b (Python)
bash scripts/deploy_app_local.sh service-b
```

### Run Services Manually
```bash
# Service-A
cd ~/deployments/service-a/service-a
node app.js

# Service-B
cd ~/deployments/service-b/service-b
source .venv/bin/activate
python app.py
```

---

## EC2 Deployment (via Jenkins CI/CD)

### On EC2 Instance - Initial Setup
```bash
# SSH into EC2
ssh -i your-key.pem ubuntu@YOUR_EC2_IP

# Setup Jenkins and dependencies
git clone https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git
cd JOVAC-CICD-pipeline-jenkins
sudo bash scripts/setup_jenkins.sh
```

### Manual Deployment (if needed)
```bash
# On EC2 instance
cd /path/to/repo
bash scripts/deploy_app.sh service-a
bash scripts/deploy_app.sh service-b
```

### Check Service Status
```bash
# Check if services are running
sudo systemctl status service-a
sudo systemctl status service-b

# View logs
sudo journalctl -u service-a -f
sudo journalctl -u service-b -f

# Restart services
sudo systemctl restart service-a
sudo systemctl restart service-b
```

---

## Jenkins Commands

### Access Jenkins
- URL: `http://YOUR_EC2_IP:8080`
- Default user: `admin`
- Password: Check `/var/lib/jenkins/secrets/initialAdminPassword` on EC2

### Jenkins Service Management
```bash
# Check Jenkins status
sudo systemctl status jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log
```

### Trigger Jenkins Build
1. **Via Web UI**: Go to pipeline → Click "Build Now"
2. **Via GitHub**: Push to `main` branch (if webhook configured)
3. **Via CLI**:
   ```bash
   curl -X POST http://YOUR_EC2_IP:8080/job/JOVAC-CICD-Pipeline/build \
     --user admin:password
   ```

---

## AWS Commands

### Get EC2 Instance IP
```bash
# From AWS CLI
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,State.Name]' --output table

# Or check AWS Console → EC2 → Instances
```

### Update Security Group (Allow Jenkins Access)
```bash
# Add rule to allow port 8080
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxx \
  --protocol tcp \
  --port 8080 \
  --cidr 0.0.0.0/0
```

---

## GitHub Setup

### Create Personal Access Token
1. GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token (classic)
3. Scopes: `repo`, `admin:repo_hook`
4. Copy token (use in Jenkins credentials)

### Configure Webhook
- **URL**: `http://YOUR_EC2_IP:8080/github-webhook/`
- **Events**: Push events
- **Content type**: application/json

---

## Troubleshooting Commands

### Check Network Connectivity
```bash
# From local machine to EC2
ping YOUR_EC2_IP

# Check if Jenkins is accessible
curl http://YOUR_EC2_IP:8080

# Test SSH connection
ssh -i your-key.pem ubuntu@YOUR_EC2_IP
```

### Check Service Dependencies
```bash
# On EC2
node --version
npm --version
python3 --version
pip --version
git --version
java -version
```

### View Deployment Logs
```bash
# Jenkins build logs
# Go to Jenkins UI → Pipeline → Build → Console Output

# Service logs on EC2
sudo journalctl -u service-a -n 100
sudo journalctl -u service-b -n 100
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Fix line endings | `sed -i 's/\r$//' scripts/*.sh` |
| Deploy locally | `bash scripts/deploy_app_local.sh service-a` |
| Setup Jenkins on EC2 | `sudo bash scripts/setup_jenkins.sh` |
| Check service status | `sudo systemctl status service-a` |
| View service logs | `sudo journalctl -u service-a -f` |
| Restart service | `sudo systemctl restart service-a` |



