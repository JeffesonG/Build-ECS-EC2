output "elb-arn" {
  value = aws_lb.publicALB.arn
}
output "elb-id" {
  value = aws_lb.publicALB.id
}
output "listener_http_to_https" {
  value = aws_lb_listener.listener_http_to_https
}
output "listener_https" {
  value = aws_lb_listener.listener_https
}

output "target-group-id" {
  value = aws_lb_target_group.target-group.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}