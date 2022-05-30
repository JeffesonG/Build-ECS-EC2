resource "aws_security_group" "allow_internet" {
  name = format("%s-AllowWebServer", var.cluster_name)

  description = "Enables access to all VPC protocols and IPs"
  vpc_id      = aws_vpc.cluster_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.cluster_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = format("%s-alb-sg", var.cluster_name)
  }

}