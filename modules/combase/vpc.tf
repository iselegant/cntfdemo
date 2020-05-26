locals {
  vpc_name      = "${var.resource_id}-vpc"
  igw_name      = "${var.resource_id}-igw"
  subnet_prefix = "${var.resource_id}-subnet"
  route_prefix  = "${var.resource_id}-route"
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

resource "aws_route_table_association" "ingress_internet" {
  for_each = var.subnet_cidr_block_ingress

  subnet_id      = aws_subnet.ingress[each.key].id
  route_table_id = aws_route_table.internet.id
}

resource "aws_route_table_association" "management_internet" {
  for_each = var.subnet_cidr_block_management

  subnet_id      = aws_subnet.management[each.key].id
  route_table_id = aws_route_table.internet.id
}
