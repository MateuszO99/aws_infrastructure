resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "My main VPC"
  }
}

#output "main_vpc_id" {
#  value = aws_vpc.main_vpc.id
#}