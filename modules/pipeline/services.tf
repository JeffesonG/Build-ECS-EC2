resource "aws_ecs_service" "service" {

  name            = var.cluster_name
  task_definition = aws_ecs_task_definition.taskDefinition.arn
  cluster         = var.ecs-id
  desired_count   = 1
  network_configuration {
    security_groups = [var.security_groups_ids]
    subnets         = [var.private_subnet_1a, var.private_subnet_1c]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.targetGroup-back.arn
    container_name   = "${var.ProjectName}-container"
    container_port   = var.container_Port
  }

}