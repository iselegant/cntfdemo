resource "aws_iam_role" "cloud9" {
  name               = "${var.resource_id}-cloud9-role"
  assume_role_policy = data.aws_iam_policy_document.cloud9.json
}

resource "aws_iam_instance_profile" "cloud9" {
  name = "${var.resource_id}-cloud9-role"
  role = aws_iam_role.cloud9.name
}

resource "aws_iam_role_policy" "cloud9" {
  name = "${var.resource_id}-AccessingECRRepositoryPolicy"
  role = aws_iam_role.cloud9.id

  policy = data.aws_iam_policy_document.cloud9_policy.json
}


data "aws_iam_policy_document" "cloud9" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cloud9_policy" {
  statement {
    sid     = "ListImagesInRepository"
    effect  = "Allow"
    actions = ["ecr:ListImages"]

    # FIXME: add AWS Account ID as tfvars
    # FIXME: replace repos name using tfvars
    resources = ["arn:aws:ecr:${var.region}::repository/cnappdemo"]
  }

  statement {
    sid       = "GetAuthorizationToken"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "ManageRepositoryContents"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    # FIXME: add AWS Account ID as tfvars
    # FIXME: replace repos name using tfvars
    resources = ["arn:aws:ecr:${var.region}::repository/cnappdemo"]
  }
}