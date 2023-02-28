# Jenkins on AWS

## Prerequisites

Required steps to run Jenkins server: 

1. Log in to your AWS account, select EC2 &rarr; Instances &rarr; Jenkins 
2. Copy Public IP address to the clipboard
3. Open `http://<Public IP address>:8080/` in browser
4. Connect to your instance via SSH using `ssh ubuntu@<Public IP address>`
5. Type `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` and paste output to the browser 
6. Skip installation of plugins, clicking close button on top right corner. Then click "Start using jenkins"
7. Click on admin profile, select Configuration tab and change password

## Useful links
TBD

## SSH preparation

1. Before running `terraform apply` make sure you generated two keys (private and public) in the terraform directory.
   To do that, run command:
    ```shell
    ssh-keygen -t rsa -b 4096
    ```
2. You will be asked to enter file in which key will be saved.
    ```
    Enter file in which to save the key: ${project_path}/terraform/jenkins-ssh-key
    ```
3. After that place content the of public key in the instances.tf like that:
    ```terraform
    resource "aws_key_pair" "connect_to_ec2" {
      key_name   = "jenkins-ssh-key"
      public_key = "ssh-rsa AAAAB3Nza..."
    }
    ```

## Agent configuration

1. Go to `Manage Jenkins > Manage Nodes` and then select `New Node`.
2. Give the node name and select `Permanent Agent` and click `ok`.
3. In `Remote root directory` enter `/opt/jenkins-agent`.
4. As a `Launch method` select `Launch against via SSH`.
5. In `Host` field enter agent's ip address.
6. Next to `Credentials` click in add button to add credentials.
7. Select `SSH Username with private key` as a kind of credentials.
8. In `Username` field enter `ubuntu`.
9. Select option `Private key enter directly` and paste private key.
10. Save the credentials, and select them to use.
11. As a `Host Key Verification Strategy` select `Non verifying Verification Strategy`.
12. Save.
