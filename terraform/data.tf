resource "aws_secretsmanager_secret_version" "jenkins-ssh-secret" {
  secret_id     = aws_secretsmanager_secret.jenkins-ssh-key.id
  secret_string = filebase64("./jenkins-ssh-key")
}

resource "aws_secretsmanager_secret" "jenkins-ssh-key" {
  name = "jenkins-ssh-private-key"
}

data "aws_secretsmanager_secret" "jenkins-ssh-key" {
  arn = aws_secretsmanager_secret.jenkins-ssh-key.arn
}

data "aws_secretsmanager_secret_version" "jenkins-ssh-key" {
  secret_id = data.aws_secretsmanager_secret.jenkins-ssh-key.id
}

resource "aws_secretsmanager_secret_version" "jenkins-ssh-secret-public-key" {
  secret_id     = aws_secretsmanager_secret.jenkins-ssh-public-key.id
  secret_string = file("./jenkins-ssh-key.pub")
}

resource "aws_secretsmanager_secret" "jenkins-ssh-public-key" {
  name = "jenkins-ssh-public-key"
}

data "aws_secretsmanager_secret" "jenkins-ssh-public-key" {
  arn = aws_secretsmanager_secret.jenkins-ssh-public-key.arn
}

data "aws_secretsmanager_secret_version" "jenkins-ssh-public-key" {
  secret_id = data.aws_secretsmanager_secret.jenkins-ssh-public-key.id
}
