locals {
  tg_pfx           = "${var.resource_id}-tg"
  healthcheck_path = "/healthcheck"
}


# ---------------------------------
#  ALB Listener Rules
# ---------------------------------
resource "aws_lb_listener_rule" "blue" {
  listener_arn = var.lb_listener_public_blue_arn
  priority     = var.lb_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = [
      priority,
      action,
    ]
  }
}

resource "aws_lb_target_group" "blue" {
  name        = "${local.tg_pfx}-cnappdemo-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    path                = local.healthcheck_path
    matcher             = 200
  }

  vpc_id = var.vpc_main_id

  tags = {
    Name = "${local.tg_pfx}-cnappdemo-blue"
  }
}

resource "aws_lb_listener_rule" "green" {
  listener_arn = var.lb_listener_public_green_arn
  priority     = var.lb_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  lifecycle {
    ignore_changes = [
      priority,
      action,
    ]
  }
}

resource "aws_lb_target_group" "green" {
  name        = "${local.tg_pfx}-cnappdemo-green"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    path                = local.healthcheck_path
    matcher             = 200
  }

  vpc_id = var.vpc_main_id

  tags = {
    Name = "${local.tg_pfx}-cnappdemo-green"
  }
}
