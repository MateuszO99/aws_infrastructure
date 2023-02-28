resource "aws_iam_instance_profile" "ssm_iam_profile" {
  name = "ssm_iam_profile"
  role = aws_iam_role.ssm_iam_role.name
}

resource "aws_iam_role" "ssm_iam_role" {
  name               = "ssm-role"
  assume_role_policy = <<EOF
  {
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
    }
  }
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_iam_policy_attachment" {
  role       = aws_iam_role.ssm_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
