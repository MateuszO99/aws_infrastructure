#!/usr/bin/env bash
sudo apt update -y
sudo apt upgrade -y

sudo mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl enable amazon-ssm-agent
rm amazon-ssm-agent.deb

sudo apt install openjdk-11-jdk -y

mkdir /opt/jenkins-agent
chown "ubuntu:ubuntu" /opt/jenkins-agent -R

