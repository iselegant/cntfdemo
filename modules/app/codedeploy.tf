locals {
  codedeploy_prefix               = "AppECS-${var.resource_id}"
  codedeploy_deployment_group_pfx = "DgpECS-${var.resource_id}"
}

resource "aws_codedeploy_app" "common" {
  compute_platform = "ECS"
  name             = "${local.codedeploy_prefix}-${var.app_name}"
}

resource "aws_codedeploy_deployment_group" "common" {
  app_name               = aws_codedeploy_app.common.name
  deployment_group_name  = "${local.codedeploy_deployment_group_pfx}-${var.app_name}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  service_role_arn = var.ecs_codedeploy_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT" #ヘルスチェック成功時に自動でトラフィック切り替えを行う
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = aws_ecs_service.common.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.lb_listener_public_blue_arn]
      }

      test_traffic_route {
        listener_arns = [var.lb_listener_public_green_arn]
      }

      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}
