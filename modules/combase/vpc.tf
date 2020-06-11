locals {
  vpc_name      = "${var.resource_id}-vpc"
  igw_name      = "${var.resource_id}-igw"
  subnet_prefix = "${var.resource_id}-subnet"
  route_prefix  = "${var.resource_id}-route"
  vpce_prefix   = "${var.resource_id}-vpce"

  subnet_egress_list = [
    for az_id in keys(var.subnet_cidr_block_egress) :
    aws_subnet.egress[az_id].id
  ]
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

resource "aws_subnet" "ingress" {
  for_each = var.subnet_cidr_block_ingress

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}${each.key}"

  tags = {
    "Name" = "${local.subnet_prefix}-public-ingress-1${each.key}"
  }
}

resource "aws_subnet" "container" {
  for_each = var.subnet_cidr_block_container

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}${each.key}"

  tags = {
    "Name" = "${local.subnet_prefix}-private-container-1${each.key}"
  }
}

resource "aws_subnet" "db" {
  for_each = var.subnet_cidr_block_db

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}${each.key}"

  tags = {
    "Name" = "${local.subnet_prefix}-private-db-1${each.key}"
  }
}

resource "aws_subnet" "management" {
  for_each = var.subnet_cidr_block_management

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}${each.key}"

  tags = {
    "Name" = "${local.subnet_prefix}-public-management-1${each.key}"
  }
}

resource "aws_subnet" "egress" {
  for_each = var.subnet_cidr_block_egress

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}${each.key}"

  tags = {
    "Name" = "${local.subnet_prefix}-public-egress-1${each.key}"
  }
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    "Name" = "${local.route_prefix}-internet"
  }
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "${local.route_prefix}-app"
  }
}

resource "aws_route_table" "management" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    "Name" = "${local.route_prefix}-management"
  }
}

resource "aws_route_table_association" "ingress_internet" {
  for_each = var.subnet_cidr_block_ingress

  subnet_id      = aws_subnet.ingress[each.key].id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "management_internet" {
  for_each = var.subnet_cidr_block_management

  subnet_id      = aws_subnet.management[each.key].id
  route_table_id = aws_route_table.management.id
}

resource "aws_route_table_association" "app_vpce" {
  for_each = var.subnet_cidr_block_container

  subnet_id      = aws_subnet.container[each.key].id
  route_table_id = aws_route_table.app.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.s3"

  route_table_ids = [
    aws_route_table.app.id,
    aws_route_table.management.id,
  ]

  tags = {
    "Name" = "${local.vpc_name}-s3"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids          = local.subnet_egress_list
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = {
    "Name" = "${local.vpc_name}-ecr-api"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  subnet_ids          = local.subnet_egress_list
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = {
    "Name" = "${local.vpc_name}-ecr-dkr"
  }
}

output "vpc_main_id" {
  value = aws_vpc.main.id
}

output "subnet_ingress" {
  value = {
    for subnet in aws_subnet.ingress :
    subnet.availability_zone => subnet.id
  }
}