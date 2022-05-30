data "template_file" "buildspec" {
  template = file("${path.module}/templates/buildspec.yml")

  vars = {
    "repository_url" = "${aws_ecr_repository.repro.repository_url}"
    "region"         = "${var.aws_region}"
    "cluster_name"   = "${var.cluster_name}"

  }
}

resource "aws_codebuild_project" "app_build" {
  name          = "${var.cluster_name}-codebuild"
  build_timeout = "60"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }
}
