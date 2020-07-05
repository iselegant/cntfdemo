resource "aws_codecommit_repository" "dev_repository" {
  repository_name = "${var.resource_id}-repo"
  description = "cnfs private repository"
}