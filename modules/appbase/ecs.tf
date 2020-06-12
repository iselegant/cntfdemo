resource "aws_ecs_cluster" "share" {
  name = "${var.resource_id}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.share.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.share.name
}
