terraform {
  required_version = "v0.12.25"

  backend "s3" {}
}

provider "aws" {
  version = "2.63.0"
  region  = var.region
}

module "base" {
  source = "../../modules/combase"

  region      = var.region
  resource_id = var.resource_id

  vpc_cidr_block_v4            = var.vpc_cidr_block_v4
  subnet_cidr_block_ingress    = var.subnet_cidr_block_ingress
  subnet_cidr_block_container  = var.subnet_cidr_block_container
  subnet_cidr_block_db         = var.subnet_cidr_block_db
  subnet_cidr_block_management = var.subnet_cidr_block_management
}

module "appbase" {
  source = "../../modules/appbase"

  resource_id = var.resource_id
  region      = var.region

  waf_header_string = var.waf_header_string

  vpc_main_id               = module.base.vpc_main_id
  security_group_ingress_id = module.base.security_group_ingress_id
  subnet_ingress            = module.base.subnet_ingress
}
