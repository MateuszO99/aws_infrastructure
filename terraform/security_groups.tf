resource "aws_security_group" "traffic" {
  name   = "traffic"
  vpc_id = aws_vpc.main_vpc.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_rules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#resource "aws_security_group" "jump_box_group" {
#  name   = "jump_ox_group"
#  vpc_id = var.vpc_id
#
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#

resource "aws_security_group" "private_group" {
  name   = "private_group"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.traffic.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#output "webtraffic_id" {
#  value = aws_security_group.webtraffic.id
#}
#
#output "jump_box_group_id" {
#  value = aws_security_group.jump_box_group.id
#}
#
#output "private_group_id" {
#  value = aws_security_group.private_group.id
#}
