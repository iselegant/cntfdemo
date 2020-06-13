locals {
  sg_pfx = "${var.resource_id}-sg"
}

resource "aws_security_group" "ingress" {
  name   = "${local.sg_pfx}-ingress"
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
    "Name" = "${local.sg_pfx}-ingress"
  }
}

output "security_group_ingress_id" {
  value = aws_security_group.ingress.id
}
