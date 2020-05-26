locals {
  vpc_name = "${var.resource_id}-vpc"
  igw_name = "${var.resource_id}-igw"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block_v4
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    "Name" = local.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = local.igw_name
  }
}