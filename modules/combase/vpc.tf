locals {
  vpc_name = "${var.resource_id}-vpc"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block_v4
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    "Name" = local.vpc_name
  }
}