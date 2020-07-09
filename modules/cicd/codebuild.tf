resource "aws_codebuild_project" "app" {
  name         = var.codebuild_name
  description  = "cnfs codebuild"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name = var.codebuild_name
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.repo_name}"
    git_clone_depth = 1
  }
  source_version = "refs/heads/master"

  tags = {
    Environment = "develop"
  }
}