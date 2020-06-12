resource "aws_service_discovery_private_dns_namespace" "common" {
  name = "local"
  vpc  = var.vpc_main_id
}

resource "aws_service_discovery_service" "app" {
  name = "${var.resource_id}-ecs-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.common.id

    dns_records {
      ttl  = 60
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
}

