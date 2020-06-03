# ---------------------------------
#  ECR Repository
# ---------------------------------
resource "aws_ecr_repository" "app" {
  name                 = "${var.resource_id}demo"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy     = file("../../modules/app/json/ecr-lifecycle-policy.json")

  depends_on = [aws_ecr_repository.app]
}
