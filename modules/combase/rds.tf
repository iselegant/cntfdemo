locals {
  aurora_prefix         = "${var.resource_id}-db"
  db_subnet_group_name  = "${var.resource_id}-rds-subnet-group"
  aurora_engine         = "aurora-mysql"
  aurora_engine_version = "5.7.mysql_aurora.2.07.2" # 2020-06時点の最新のバージョン

}

resource "aws_db_subnet_group" "main" {
  name        = local.db_subnet_group_name
  description = "cnapp-rds-subnet-group"

  subnet_ids = [
    for az_id in keys(var.subnet_cidr_block_db) :
    aws_subnet.db[az_id].id
  ]
}

# Aurora作成後、パスワードは適宜変更すること
resource "aws_rds_cluster" "main" {
  cluster_identifier  = local.aurora_prefix
  engine              = local.aurora_engine
  engine_version      = local.aurora_engine_version
  engine_mode         = "provisioned"
  database_name       = var.resource_id
  deletion_protection = true

  availability_zones = [
    for az_id in keys(var.subnet_cidr_block_db) :
    "${var.region}${az_id}"
  ]

  master_username                 = "admin"
  master_password                 = "password"
  backup_retention_period         = 1
  preferred_backup_window         = "09:00-09:30"
  preferred_maintenance_window    = "sat:20:00-sat:20:30"
  port                            = 3306
  vpc_security_group_ids          = [aws_security_group.db.id]
  db_subnet_group_name            = local.db_subnet_group_name
  storage_encrypted               = true
  apply_immediately               = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

  // aws_rds_clusterリソースを作成すると、AZを2つ(a,c)のみ指定しているのに関わらず、
  // 3つ(a,c,d)として作成されるので、毎回差分として検出される。そのため、AZの差分を無視する。
  lifecycle {
    ignore_changes = [
      availability_zones,
      master_password,
      final_snapshot_identifier,
    ]
  }
}

resource "aws_rds_cluster_instance" "main" {
  count                        = var.aurora_instance_count
  engine                       = local.aurora_engine
  identifier                   = "${local.aurora_prefix}-instance-${count.index}"
  cluster_identifier           = aws_rds_cluster.main.id
  instance_class               = var.aurora_instance_class
  publicly_accessible          = false
  monitoring_role_arn          = aws_iam_role.rds_monitoring.arn
  monitoring_interval          = 60
  preferred_maintenance_window = "sat:21:00-sat:21:30"
  auto_minor_version_upgrade   = true
}
