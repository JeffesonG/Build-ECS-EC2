resource "aws_ecs_cluster" "cluster-ecs" {
  name = var.cluster_name

  tags = {
    Name = format("%s-Cluster", var.cluster_name)
  }
}
resource "aws_cloudwatch_log_group" "logs" {
  name = "${var.cluster_name}-logs"

  tags = {
    App = format("%s-logs", var.cluster_name)
  }
}
