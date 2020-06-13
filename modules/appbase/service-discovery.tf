resource "aws_service_discovery_private_dns_namespace" "common" {
  name = "local"
  vpc  = var.vpc_main_id
}

output "sd_ns_common_id" {
  value = aws_service_discovery_private_dns_namespace.common.id
}
