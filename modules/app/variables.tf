variable "resource_id" {}
variable "region" {}

variable "lb_priority" {}
variable "ecs_service_desired_count" {}
variable "ecs_task_cpu" {}
variable "ecs_task_memory" {}
variable "ecs_container_cpu" {}
variable "ecs_container_memory" {}
variable "as_min_capacity" {}
variable "as_max_capacity" {}

variable "vpc_main_id" {}
variable "subnet_container" {}
variable "security_group_container_id" {}
variable "lb_listener_public_blue_arn" {}
variable "lb_listener_public_green_arn" {}
variable "ecs_cluster_arn" {}
variable "ecs_cluster_name" {}

variable "container_name" {}