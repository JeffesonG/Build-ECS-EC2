resource "aws_lb_target_group" "targetGroup-back" {
  name        = format("td-%s", var.ProjectName)
  port        = var.container_Port
  protocol    = "HTTP"
  vpc_id      = var.cluster_vpc
  target_type = "ip"

  health_check {
    matcher = "200-499"
  }
}

resource "aws_lb_listener" "SiteNameListener" {
  load_balancer_arn = var.elb-arn
  port              = var.container_Port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetGroup-back.arn
  }
}
