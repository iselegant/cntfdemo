locals {
  sg_pfx = "${var.resource_id}-sg"
}

resource "aws_security_group" "ingress" {
  name   = "${local.sg_pfx}-ingress"
  vpc_id = var.vpc_main_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${local.sg_pfx}-ingress"
  }
}