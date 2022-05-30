resource "aws_vpc" "cluster_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = format("%s-vpc", var.cluster_name)
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cluster_vpc.id

  tags = {
    "Name" = format("%s-igw", var.cluster_name)
  }
}

