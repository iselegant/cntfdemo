terraform {
  required_version = "v0.12.28"

  backend "s3" {}
}

provider "aws" {
  version = "2.70.0"
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

  lb_priority               = var.lb_priority
  ecs_service_desired_count = var.ecs_service_desired_count
  ecs_task_cpu              = var.ecs_task_cpu
  ecs_task_memory           = var.ecs_task_memory
  ecs_container_memory      = var.ecs_container_memory
  ecs_container_cpu         = var.ecs_container_cpu
  as_min_capacity           = var.as_min_capacity
  as_max_capacity           = var.as_max_capacity

  resource_id    = var.resource_id
  region         = var.region
  container_name = var.demo_app_name

  app_name                     = var.app_name
  vpc_main_id                  = data.terraform_remote_state.base.outputs.vpc_main_id
  subnet_container             = data.terraform_remote_state.base.outputs.subnet_container
  security_group_container_id  = data.terraform_remote_state.base.outputs.security_group_container_id
  lb_listener_public_blue_arn  = data.terraform_remote_state.base.outputs.lb_listener_public_blue_arn
  lb_listener_public_green_arn = data.terraform_remote_state.base.outputs.lb_listener_public_green_arn
  ecs_cluster_arn              = data.terraform_remote_state.base.outputs.ecs_cluster_arn
  ecs_cluster_name             = data.terraform_remote_state.base.outputs.ecs_cluster_name
  ecs_task_role_arn            = data.terraform_remote_state.base.outputs.ecs_task_role_arn
  ecs_codedeploy_role_arn      = data.terraform_remote_state.base.outputs.ecs_codedeploy_role_arn
  sd_ns_common_id              = data.terraform_remote_state.base.outputs.sd_ns_common_id
}

module "cicd" {
  source = "../../modules/cicd"

  repo_name   = "${var.resource_id}-repo"
}