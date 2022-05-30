resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-${var.cluster_name}-role"
  assume_role_policy = file("${path.module}/templates/policies/codepipeline_role.json")
}

data "template_file" "codepipeline_policy" {
  template = file("${path.module}/templates/policies/codepipeline.json")
  vars = {
    aws_s3_bucket_arn = "${aws_s3_bucket.bucket.arn}"
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline-${var.cluster_name}-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.template_file.codepipeline_policy.rendered
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-${var.cluster_name}-role"
  assume_role_policy = file("${path.module}/templates/policies/codebuild_role.json")
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/templates/policies/codebuild_policy.json")

  vars = {
    aws_s3_bucket_arn = "${aws_s3_bucket.bucket.arn}"
  }

}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-${var.cluster_name}-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.cluster_name}-ecs_task_role"
  assume_role_policy = file("${path.module}/templates/policies/ecs-task-execution-role.json")
}

# Cluster Execution Policy
resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "${var.cluster_name}_role_policy"
  policy = file("${path.module}/templates/policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}