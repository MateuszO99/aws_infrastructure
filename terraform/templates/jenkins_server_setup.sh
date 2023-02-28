#!/usr/bin/env bash
sudo apt update -y
sudo apt install openjdk-11-jdk -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
sudo wget http://localhost:8080/jnlpJars/jenkins-cli.jar
sudo systemctl start jenkins
initialAdminPassword=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
sudo java -jar jenkins-cli.jar -auth admin:"${initialAdminPassword}" -s \
 http://localhost:8080 install-plugin cloudbees-folder antisamy-markup-formatter build-timeout \
  credentials-binding timestamper ws-cleanup ant gradle workflow-aggregator github-branch-source \
   pipeline-github-lib pipeline-stage-view git ssh-slaves matrix-auth pam-auth ldap email-ext mailer

sudo cat job-config.xml | sudo java -jar jenkins-cli.jar -auth admin:"${initialAdminPassword}" -s \
  http://localhost:8080/ create-job test-pipeline

sudo systemctl restart jenkins
