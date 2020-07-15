resource "aws_iam_role" "codebuild" {
  name               = "${var.resource_id}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_policy" "codebuild" {
  name   = "${var.resource_id}-CodeBuildBasePolicy"
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  policy_arn = aws_iam_policy.codebuild.arn
  role       = aws_iam_role.codebuild.name
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.resource_id}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_policy" "codepipeline" {
  name   = "${var.resource_id}-CodePipelineBasePolicy"
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  policy_arn = aws_iam_policy.codepipeline.arn
  role       = aws_iam_role.codepipeline.name
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
    sid       = "s3"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
  }

  statement {
    sid    = "CloudWatch"
    effect = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ecr:GetAuthorizationToken"]
  }

  statement {
    sid       = "ECR"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
  }

  statement {
    sid    = "CodeCommit"
    effect = "Allow"
    resources = ["*"]
    actions = [
      "codecommit:GitPull"
    ]
  }

  statement {
    sid    = "CodeBuild"
    effect = "Allow"
    resources = ["*"]
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases"
    ]
  }
}

data "aws_iam_policy_document" "codepipeline" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline_policy" {
  version = "2012-10-17"

  statement {
    sid       = "Pass"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]
    condition {
      test = "StringEqualsIfExists"
      values = [
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
      variable = "iam:PassedToService"
    }
  }

  statement {
    sid    = "CodeCommit"
    effect = "Allow"
    resources = ["*"]
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]
  }

  statement {
    sid       = "CodeBuild"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
  }

  statement {
    sid       = "CodeDeploy"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
  }

  statement {
    sid    = "s3"
    effect = "Allow"
    resources = [
      aws_s3_bucket.artifact.arn,
      "${aws_s3_bucket.artifact.arn}/*"
    ]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning"
    ]
  }

  statement {
    sid       = "ECS"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]
  }
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild.arn
}

output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline.arn
}
