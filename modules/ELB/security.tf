#====================Security Groups ALB ==========================

resource "aws_security_group" "alb_sg" {
  name = format("%s-Alb-sg", var.cluster_name)

  description = "Enables access to all IPs to port 80 and 443"
  vpc_id      = var.cluster_vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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