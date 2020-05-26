variable "resource_id" {}
variable "region" {}

variable "vpc_cidr_block_v4" {}
variable "subnet_cidr_block_ingress" {
  type = map(string)
}
variable "subnet_cidr_block_container" {
  type = map(string)
}
variable "subnet_cidr_block_db" {
  type = map(string)
}
variable "subnet_cidr_block_management" {
  type = map(string)
}