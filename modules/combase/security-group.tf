locals {
  sg_prefix = "${var.resource_id}-sg"
}

resource "aws_security_group" "ingress" {
  name   = "${local.sg_prefix}-ingress"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${local.sg_prefix}-ingress"
  }
}

resource "aws_security_group" "vpce" {

  name   = "${local.sg_prefix}-vpce"
  vpc_id = aws_vpc.main.id

  # Cloud9のセキュリティグループIDをTerraformリソースから取得できないため、
  # ここでは暫定的にCloud9インスタンスが所属するサブネットCIDRで定義する
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = values(var.subnet_cidr_block_management)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.container.id]
  }

  tags = {
    "Name" = "${local.sg_prefix}-vpce"
  }
}

resource "aws_security_group" "container" {

  name   = "${local.sg_prefix}-container"
  vpc_id = aws_vpc.main.id
  description = "Security Group of VPC Container App"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.ingress.id]
    description = "HTTP for Ingress"
  }

  # Cloud9のセキュリティグループIDをTerraformリソースから取得できないため、
  # ここでは暫定的にCloud9インスタンスが所属するサブネットCIDRで定義する
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = values(var.subnet_cidr_block_management)
    description = "HTTP for Cloud9"
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = values(var.subnet_cidr_block_management)
    description = "ICMP for Cloud9"
  }

  tags = {
    "Name" = "${local.sg_prefix}-container"
  }
}

output "security_group_ingress_id" {
  value = aws_security_group.ingress.id
}
