output "vpc_main_id" {
  value = module.base.vpc_main_id
}

output "subnet_container" {
  value = module.base.subnet_container
}

output "security_group_ingress_id" {
  value = module.base.security_group_ingress_id
}

output "security_group_container_id" {
  value = module.base.security_group_container_id
}

output "lb_listener_public_blue_arn" {
  value = module.appbase.lb_listener_public_blue_arn
}

output "lb_listener_public_green_arn" {
  value = module.appbase.lb_listener_public_green_arn
}

output "ecs_cluster_arn" {
  value = module.appbase.ecs_cluster_arn
}

output "ecs_cluster_name" {
  value = module.appbase.ecs_cluster_name
}

output "ecs_task_role_arn" {
  value = module.appbase.ecs_task_role_arn
}

output "ecs_codedeploy_role_arn" {
  value = module.appbase.ecs_codedeploy_role_arn
}

output "sd_ns_common_id" {
  value = module.appbase.sd_ns_common_id
}

output "codebuild_role_arn" {
  value = module.cicdbase.codebuild_role_arn
}