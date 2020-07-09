resource "aws_codecommit_repository" "dev_repository" {
  repository_name = var.repo_name
  description = "cnfs private repository"
}