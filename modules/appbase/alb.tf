locals {
  alb_pfx = "${var.resource_id}-alb"
  tg_pfx  = "${var.resource_id}-tg"
}

resource "aws_lb" "public" {
  name               = "${local.alb_pfx}-ingress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ingress.id]
  subnets = [
    for subnet_id in var.subnet_ingress :
    subnet_id
  ]

  enable_deletion_protection       = true
  enable_cross_zone_load_balancing = true
  ip_address_type                  = "ipv4"

  tags = {
    Name = "${local.alb_pfx}-ingress"
  }
}

resource "aws_lb_listener" "public_blue" {
  load_balancer_arn = aws_lb.public.arn
  protocol          = "HTTP"
  port              = "80"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dummy.arn
  }

  # blue/greenデプロイ時にターゲットグループ入替による
  # default_actionが変更となるため、ignore設定として追加。
  lifecycle {
    ignore_changes = [default_action]
  }
}

# 実際のECSタスクに紐づくターゲットグループ定義は同じライフサイクルである
# ECSタスクと同じリソースライフサイクルであるmodulues/appで定義する。
# 一方、Listener定義時にデフォルトアクションとしてターゲットグループを
# 定義する必要がある。そのため、以下ダミー用定義としてリソースを作成する。
resource "aws_lb_target_group" "dummy" {
  name        = "${local.tg_pfx}-dummy"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_main_id

  tags = {
    Name = "${local.tg_pfx}-dummy"
  }
}

output "lb_public_arn_suffix" {
  value = aws_lb.public.arn_suffix
}

output "lb_listener_public_blue_arn" {
  value = aws_lb_listener.public_blue.arn
}
