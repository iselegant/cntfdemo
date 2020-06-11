output "vpc_main_id" {
  value = module.base.vpc_main_id
}

output "security_group_ingress_id" {
  value = module.base.security_group_ingress_id
}

output "lb_listener_public_blue_arn" {
  value = module.appbase.lb_listener_public_blue_arn
}
