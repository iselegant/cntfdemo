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

  aws_account_id = var.aws_account_id

  region        = var.region
  resource_id   = var.resource_id
  demo_app_name = var.demo_app_name

  vpc_cidr_block_v4            = var.vpc_cidr_block_v4
  subnet_cidr_block_ingress    = var.subnet_cidr_block_ingress
  subnet_cidr_block_container  = var.subnet_cidr_block_container
  subnet_cidr_block_db         = var.subnet_cidr_block_db
  subnet_cidr_block_management = var.subnet_cidr_block_management
  subnet_cidr_block_egress     = var.subnet_cidr_block_egress
  aurora_instance_count        = var.aurora_instance_count
  aurora_instance_class        = var.aurora_instance_class
  ssm_params_db_user           = var.ssm_params_db_user
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
