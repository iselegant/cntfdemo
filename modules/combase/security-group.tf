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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

  tags = {
    "Name" = "${local.sg_prefix}-vpce"
  }
}

output "security_group_ingress_id" {
  value = aws_security_group.ingress.id
}
