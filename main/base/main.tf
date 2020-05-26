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

  resource_id       = var.resource_id
  vpc_cidr_block_v4 = var.vpc_cidr_block_v4
}

module "appbase" {
  source = "../../modules/appbase"
}

module "cicdbase" {
  source = "../../modules/cicdbase"
}