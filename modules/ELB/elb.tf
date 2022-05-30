resource "aws_lb" "publicALB" {
  name               = format("public-alb-%s", var.cluster_name)
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id, var.allow_internet]
  subnets            = [var.public_subnet_1a, var.public_subnet_1c]
}

resource "aws_lb_target_group" "target-group" {
  name     = format("target-group-%s", var.cluster_name)
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.cluster_vpc
  target_type = "ip"

  health_check {
    path              = "/"
    healthy_threshold = 2
  }
}
resource "aws_lb_listener" "listener_http_to_https" {
  load_balancer_arn = aws_lb.publicALB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.publicALB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificateSSL

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }

}
