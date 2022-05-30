resource "aws_ecs_task_definition" "taskDefinition" {
  family = "${var.cluster_name}-app"
  container_definitions = jsonencode([
    {
      "name"  = "${var.ProjectName}-container",
      "image" = "${aws_ecr_repository.repro.repository_url}:latest",
      "portMappings" = [
        {
          "containerPort" = "${var.container_Port}",
          "hostPort"      = "${var.container_Port}"
        }
      ],
      "cpu"         = 512,
      "memory"      = 512,
      "networkMode" = "awsvpc",
      "essential"   = true,
      "logConfiguration" = {
        "logDriver" = "awslogs",
        "options" = {
          "awslogs-group"         = "${var.logs-name}",
          "awslogs-region"        = "${var.aws_region}",
          "awslogs-stream-prefix" = "${var.ProjectName}"
        }
      }
    }
  ])
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_execution_role.arn

}