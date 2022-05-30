resource "aws_ecr_repository" "repro" {
  name = "${var.cluster_name}-${var.ProjectName}"
}