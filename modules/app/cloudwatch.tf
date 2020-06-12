locals {
  ecs_log_group_pfx = "/ecs/${var.resource_id}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${local.ecs_log_group_pfx}-task"

  retention_in_days = 30
}