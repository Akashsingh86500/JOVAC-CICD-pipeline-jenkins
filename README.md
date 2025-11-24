# Microservices CI/CD with Jenkins and GitHub

This project deploys two microservices using Jenkins CI/CD pipeline and GitHub Webhooks.

---
## 🏗 Architecture

- Two microservices in the **same monorepo**
- Jenkins pulls code from GitHub
- Builds & deploys to AWS EC2 via SSH + systemd services

---
## 🆓 AWS Free Tier Resources

| Resource | Type | Free Tier |
|----------|------|-----------|
| Compute  | EC2 t2.micro / t3.micro | 750 hours/month |

---

## 🚀 Setup Instructions

### 1️⃣ Launch EC2 Instance

Use **Ubuntu 22.04** or **Amazon Linux 2** and install Jenkins.

Run this after connecting (SSH):

```sh
sudo bash scripts/jenkins_setup.sh
