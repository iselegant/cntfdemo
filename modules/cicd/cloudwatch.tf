resource "aws_cloudwatch_log_group" "app" {
  name              = var.codebuild_name
  retention_in_days = 30
}