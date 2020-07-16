resource "aws_ecs_service" "common" {
  name             = "${var.resource_id}-ecs-service"
  cluster          = var.ecs_cluster_arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"

  task_definition = aws_ecs_task_definition.app.arn

  # ECSサービスの差分検出を防ぐためlifecycleを設定
  # task_definition    : アプリリリース(ECRイメージリビジョン変更)やスケールアップによるECSタスク定義更新
  # load_balancer      : blue/greenデプロイ時のloadbalancerのターゲットグループ変更
  # service_registries : blue/greenデプロイ時のcontainerポート設定変更
  # desired_count      : タスク必要数の設定変更（AWSCLIによる変更を想定）
  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer,
      service_registries,
      desired_count,
    ]
  }

  desired_count                      = var.ecs_service_desired_count
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name   = var.container_name
    container_port   = 80
  }

  health_check_grace_period_seconds = 120

  network_configuration {
    subnets         = values(var.subnet_container)
    security_groups = [var.security_group_container_id]

    assign_public_ip = "false"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.app.arn
  }
}

# タスク定義の設定変更を行うと、既存定義を削除して新規定義を作成する動作になる。
# そのため、旧リビジョンが削除される動作となる。
# 旧リビジョンを残す場合は、aws_ecs_task_definitionを新規作成すること。
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.resource_id}-ecs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_task_role_arn
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = data.template_file.common.rendered

  # CodePipelineによるCI/CDを実現するためには、
  # task定義(JSON)のマスタをパイプライン側資産(アプリ資産)として扱う必要がある。
  # そのため、Terraform上ではtask定義のマスタ状態は管理せず、
  # 初期構築のみとし、作成後は定義変更の検知を無視する。
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

data "template_file" "common" {
  template = file("../../modules/app/json/ecs-container.json")

  vars = {
    region         = var.region
    resource_id    = var.resource_id
    container_name = var.container_name
    ecr_name       = aws_ecr_repository.app.repository_url
    image_revision = "v1"
    cpu            = var.ecs_container_cpu
    memory         = var.ecs_container_memory
    awslogs_group  = aws_cloudwatch_log_group.app.id
  }
}
