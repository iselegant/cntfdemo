variable "resource_id" {}
variable "region" {}

variable "vpc_main_id" {}
variable "subnet_ingress" {
  type = map(string)
}

variable "waf_header_string" {}