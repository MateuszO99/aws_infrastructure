resource "aws_key_pair" "connect_to_ec2" {
  key_name   = "jenkins-ssh-key"
  public_key = data.aws_secretsmanager_secret_version.jenkins-ssh-public-key.secret_string
}

resource "aws_instance" "jenkins_server" {
  ami                         = "ami-03e08697c325f02ab"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.connect_to_ec2.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.traffic.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_iam_profile.name
  associate_public_ip_address = true
  user_data                   = file("./templates/jenkins_server_setup.sh")

  tags = {
    Name = "Jenkins"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = base64decode(data.aws_secretsmanager_secret_version.jenkins-ssh-key.secret_string)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo ${data.aws_secretsmanager_secret_version.jenkins-ssh-key.secret_string} | base64 --decode > ~/.ssh/jenkins-ssh-key.pem",
    ]
  }
}

#resource "aws_instance" "jump_box" {
#  ami                         = var.ami
#  instance_type               = var.ins_type
#  key_name                    = aws_key_pair.connect_to_ec2.key_name
#  subnet_id                   = var.public_subnet_id
#  vpc_security_group_ids      = [var.jump_box_group_id]
#  associate_public_ip_address = true
#
#  tags = {
#    Name = "Jump-box"
#  }
#}
#
resource "aws_instance" "jenkins_agent" {
  ami                    = "ami-03e08697c325f02ab"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.connect_to_ec2.key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_iam_profile.name
  user_data              = file("./templates/jenkins_agent_configuration.sh")

  tags = {
    Name = "Jenkins agent"
  }
}
