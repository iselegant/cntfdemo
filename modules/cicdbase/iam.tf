resource "aws_iam_role" "codebuild" {
  name = "${var.resource_id}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_policy" "codebuild" {
  name="${var.resource_id}-CodeBuildBasePolicy"
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  policy_arn = aws_iam_policy.codebuild.arn
  role = aws_iam_role.codebuild.name
}

data "aws_iam_policy_document" "codebuild" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid = "s3"
    effect = "Allow"
    resources = ["*"]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
  }

  statement {
    sid = "CloudWatch"
    effect = "Allow"
    resources = [
      "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${var.codebuild_name}",
      "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:${var.codebuild_name}:*"
    ]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid="ECR"
    effect = "Allow"
    resources = ["arn:aws:ecr:${var.region}:${var.aws_account_id}:repository/${var.app_name}"]
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
  }

  statement {
    sid="CodeCommit"
    effect = "Allow"
    resources = [
      "arn:aws:codecommit:${var.region}:${var.aws_account_id}:${var.resource_id}-repo"]
    actions = [
      "codecommit:GitPull"
    ]
  }

  statement {
    sid = "CodeBuild"
    effect = "Allow"
    resources = [
      "arn:aws:codebuild:${var.region}:${var.aws_account_id}:report-group/${var.codebuild_name}-*"
    ]
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases"
    ]
  }
}
