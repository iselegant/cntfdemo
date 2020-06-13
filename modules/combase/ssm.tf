locals {
  ssm_param_prefix = "${var.resource_id}-param"
  ssm_key_id       = "alias/aws/ssm"
}

resource "aws_ssm_parameter" "db_host" {
  name  = "${local.ssm_param_prefix}-db-host"
  type  = "String"
  value = aws_rds_cluster.main.endpoint
}

resource "aws_ssm_parameter" "dbname" {
  name  = "${local.ssm_param_prefix}-db-name"
  type  = "String"
  value = aws_rds_cluster.main.database_name
}

resource "aws_ssm_parameter" "dbuser" {
  name  = "${local.ssm_param_prefix}-db-username"
  type  = "String"
  value = var.ssm_params_db_user
}

resource "aws_ssm_parameter" "dbpass" {
  name = "${local.ssm_param_prefix}-db-password"
  type = "SecureString"

  # Terraform上ではDB用パスワード情報は管理しない。
  # 初回定義作成後に手動変更する。
  value  = "dummy"
  key_id = local.ssm_key_id

  lifecycle {
    ignore_changes = [value]
  }
}
