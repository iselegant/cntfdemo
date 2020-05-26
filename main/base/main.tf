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
}

module "appbase" {
  source = "../../modules/appbase"
}

module "cicdbase" {
  source = "../../modules/cicdbase"
}