locals {
  # FIXME: pfx -> prefix
  sg_pfx = "${var.resource_id}-sg"
}

resource "aws_security_group" "vpce" {

  name   = "${local.sg_pfx}-vpce"
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
    "Name" = "${local.sg_pfx}-vpce"
  }
}