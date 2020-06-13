resource "aws_appautoscaling_target" "common" {
  min_capacity       = var.as_min_capacity
  max_capacity       = var.as_max_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.common.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name        = "${var.resource_id}-ecs-scalingpolicy"
  policy_type = "TargetTrackingScaling"
  resource_id = "service/${var.ecs_cluster_name}/${aws_ecs_service.common.name}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }

  depends_on = [aws_appautoscaling_target.common]
}
