output "ecs-id" {
  value = aws_ecs_cluster.cluster-ecs.id
}

output "logs" {
  value = aws_cloudwatch_log_group.logs.name
}