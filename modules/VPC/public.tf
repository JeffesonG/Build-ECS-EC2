resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
  availability_zone       = format("%sa", var.aws_region)

  tags = {
    Name = format("%s-pubic-1a", var.cluster_name)

  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.cluster_vpc.id

  cidr_block              = "10.0.16.0/20"
  map_public_ip_on_launch = true
  availability_zone       = format("%sc", var.aws_region)

  tags = {
    Name = format("%s-pubic-1c", var.cluster_name),
  }
}

resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id

  tags = {
    "Name" = format("%s-public-route", var.cluster_name)
  }
}

resource "aws_route" "public-internet_access" {
  route_table_id         = aws_route_table.igw_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "pubic_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table_association" "pubic_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.igw_route_table.id
}