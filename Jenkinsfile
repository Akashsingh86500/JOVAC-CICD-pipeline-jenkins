pipeline {
  agent any
  environment {
    EC2_HOST = '54.252.194.194'
    SSH_CREDENTIALS_ID = 'MIIEpAIBAAKCAQEA7LlUdZ8gwp6Fq/Bd+jZrSmO0H+JUTApvhlpJSs5RlorvM8H6
ilgop76W3lDEZMPF4177G0PFQ8QoS47kqk8jYYgXjH5EEnf4EoLADnEnwnTO7wnE
kgnYhczyy+rQLBt5z1VMwv9GnkH9dtlx8alNjJ9YFYX1xQESqB9eY6ieSwgsUsri
o2M7WeJWet9txSq7pAVs+sEVjOlYZvVGFn3xluWQIdCgFRT3am2ZJouY8E5wWtQT
Q+TlwmGFpeL2qQ7I1XSk6XoHQcm95nHN3hOu1RpH/c3JlbsFkDQREEi9svrgkbk4
+adR6rq+oCiOsJ4R1RiWZjiU1GPypxf0/HfFowIDAQABAoIBAQDl0VMu0esTJqUt
dLE3/mcRFFTF84vVOvhk3fhzuHO7DG0HuZXLg6UMnVqIwK66CNpwUEDGinfTv3dD
S5mxwhzeTipWiir6JyBekDN2keKAxbg0ly4QfaCI3Z0F3ZR2jcInSG+6i+x6LiSt
opMdgzk3gWcZljExLkZ3k+SmKghrW8irpmVOBLXU8i6djlIqbOQNBgJBYWvii0eO
pOsRqpIrXc8Quy7szfkwT5hrLMfCVdob45Wu6Ztwx6iLt4bx0fLRZwQydm367p+p
97QftcSX+6tA0CGrk88iH93iB/66BGKg8yWLtM3G99UYRFEiywd5O3lq5SDTchAC
LxEbsEuBAoGBAP7yDQdoz5+y1ZTF3xQeafesi5dmPLvatISmboMXQHbj7VWRZyu4
RiYq6bpvIjQxD9AEYOQAUgCxt7+hfOqLtgKOszAoNNEQIbEu3kcYgpdj94Ic6sYN
UxHWx8d1mz6UifYBdTzNcGmCo8L3550KquAgfh0bzBu+QVguj3IYT6JjAoGBAO2z
/DCVUfrmZqYtxO1YhbrMHRTq7sC1NRBremodKCm9sUugPFPXC2V3qjxh120xK3K7
RBD13YXMHf05IJXuylhtZhYYKj1pKtNXsWe4W5jPFtuzTVjPRoBO7U+9ljWGDT3c
vhk8T7gi/Y7Mi3BWj2V2tX5WvNlcOvbeAvSgaxPBAoGAIJpZujHYI2ceUyk+zvbY
vFivfUwQxkFAxpn2FgOaNdoOFtxCYl/tcKIaQ8JEkIIZsJNuxJmZ4wbXJcWEEQaO
3yLanXT21CmI9Xy15kenI68gDt6d03gOwIBECijrEoSyY+hp0r2++28+fAdx8i5U
Ddd56UUNxBp/hsRlicS8IlsCgYEA1u3ZaCx79fuCcVwNJfbW5HJPEWzj+MdgdbpY
873tZOCqgREfu0dEfLjY6sQlQAwnlxQQla1aYfKQYzjWZ/uEZrR0jCHJf8GqAXLX
bEtcNy15I6pak6THwJidJ27rdPYC3x7LnJHWG084KXh11FvQSRQvQ082butgPXu8
/GhYqYECgYAm+umYpEr7o1et6iTvL8gRHe3incxAj8ZJcZXvWz8pQSox2zaM67xQ
rfAF3sRze4fl+4ZcVzaLDHQpP2uNMHEWDkqICTaI/Mz+kzMRANH6myddq9Xr/WNG
0iM+JGL9gBSWv05o5MquQaA1X2BqciJ5XDIwBzSl6xEI2jU1S4QITA=='
    REPO_URL = 'https://github.com/Akashsingh86500/JOVAC-CICD-pipeline-jenkins.git'
  }
  stages {
    stage('checkout') {
      steps { checkout scm }
    }
    stage('build service-a') {
      steps { dir('service-a') { sh 'npm ci' } }
    }
    stage('build service-b') {
      steps { dir('service-b') { sh 'python -m venv .venv || true'; sh '. .venv/bin/activate; pip install -r requirements.txt' } }
    }
    stage('deploy') {
      steps {
        sshagent (credentials: [env.SSH_CREDENTIALS_ID]) {
          sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-a"
          sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_HOST} 'bash -s' < scripts/deploy_app.sh service-b"
        }
      }
    }
  }
}
