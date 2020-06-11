terraform {
  required_version = "v0.12.25"

  backend "s3" {}
}

provider "aws" {
  version = "2.63.0"
  region  = var.region
}

data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket = "cnapp-terraform-${var.aws_account_id}"
    key    = "base/terraform.tfstate"
    region = var.region
  }
}


module "app" {
  source = "../../modules/app"

  lb_priority = var.lb_priority

  resource_id = var.resource_id

  vpc_main_id                 = data.terraform_remote_state.base.outputs.vpc_main_id
  lb_listener_public_blue_arn = data.terraform_remote_state.base.outputs.lb_listener_public_blue_arn
  lb_listener_public_green_arn = data.terraform_remote_state.base.outputs.lb_listener_public_green_arn
}

