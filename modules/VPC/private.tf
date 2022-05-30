resource "aws_subnet" "private_subnet_1a" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block        = "10.0.32.0/20"
  availability_zone = format("%sa", var.aws_region)

  tags = {
    Name = format("%s-private-1a", var.cluster_name)
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block        = "10.0.48.0/20"
  availability_zone = format("%sc", var.aws_region)

  tags = {
    Name = format("%s-private-1c", var.cluster_name)

  }
}
resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.cluster_vpc.id

  tags = {
    Name = format("%s-private-route", var.cluster_name)
  }
}

resource "aws_route" "nat_access" {
  route_table_id         = aws_route_table.nat.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


resource "aws_eip" "vpc_eip" {
  vpc = true

  tags = {
    Name = format("%s-eip", var.cluster_name)
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.vpc_eip.id
  subnet_id     = aws_subnet.private_subnet_1a.id

  tags = {
    Name = format("%s-nat-gateway", var.cluster_name)
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.nat.id
}
resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.nat.id
}