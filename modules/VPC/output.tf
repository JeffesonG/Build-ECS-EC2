output "cluster_vpc" {
  value = aws_vpc.cluster_vpc.id
}

output "public_subnet_1a" {
  value = aws_subnet.public_subnet_1a.id
}

output "public_subnet_1c" {
  value = aws_subnet.public_subnet_1c.id
}

output "private_subnet_1a" {
  value = aws_subnet.private_subnet_1a.id
}

output "private_subnet_1c" {
  value = aws_subnet.private_subnet_1c.id
}

output "allow_internet" {
  value = aws_security_group.allow_internet.id
}