# Microservices CI/CD with Jenkins and GitHub

Architecture: two microservices in the same repository. Jenkins builds each service from GitHub and deploys to a free-tier EC2 instance via SSH and systemd.

Free-tier AWS resources:
- EC2 t2.micro / t3.micro for Jenkins or application host (750 hours per month free for 12 months)

Setup summary:
1. Create an EC2 instance (Amazon Linux 2 or Ubuntu) and run `scripts/jenkins_setup.sh` as root.
2. Create a Jenkins pipeline job pointing to this repository and set environment variables: `EC2_HOST`, `SSH_CREDENTIALS_ID`, and (optionally) `REPO_URL`.
	- Example: `EC2_HOST=1.2.3.4`, `SSH_CREDENTIALS_ID=my-ec2-ssh-key`, `REPO_URL=https://github.com/your-org/your-repo.git`
3. Install a GitHub repository deploy key or add your EC2 SSH key to Jenkins credentials (type: SSH Username with private key).
4. Run the pipeline. Jenkins will build both services and SSH to the EC2 host to run `scripts/deploy_app.sh service-a` and `scripts/deploy_app.sh service-b`.

Notes:
- `scripts/deploy_app.sh` now reads `REPO_URL` from the environment if provided; otherwise it falls back to the repository's default URL. You can set `REPO_URL` in the Jenkins pipeline environment to point to a fork or a private repo.
- The deployment scripts assume the EC2 remote user is `ec2-user` (Amazon Linux). If your instance uses `ubuntu` (Ubuntu AMIs), update the `Jenkinsfile` SSH target or the `scripts/deploy_app.sh` usage accordingly.
- `service-b/requirements.txt` has been added (Flask and flask-cors). Ensure `service-b`'s `requirements.txt` matches your production dependencies.