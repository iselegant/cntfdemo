resource "aws_iam_role" "ecs_task" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_ssm" {
  name = "${var.resource_id}-GettingParameterStorePolicy"
  role = aws_iam_role.ecs_task.id

  policy = data.aws_iam_policy_document.ssm_policy.json
}


data "aws_iam_policy_document" "ecs_task" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue"
    ]
    resources = ["*"]
  }
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task.arn
}

resource "aws_iam_role" "ecs_codedeploy" {
  name               = "ecsCodeDeployRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_codedeploy.json
}

resource "aws_iam_role_policy_attachment" "ecs_codedeploy" {
  role       = aws_iam_role.ecs_codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECSLimited"
}

data "aws_iam_policy_document" "ecs_codedeploy" {
  version = "2012-10-17"

  statement {
    sid    = ""
    effect = "Allow"
    actions = [
    "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
      "codedeploy.amazonaws.com"]
    }
  }
}

output "ecs_codedeploy_role_arn" {
  value = aws_iam_role.ecs_codedeploy.arn
}