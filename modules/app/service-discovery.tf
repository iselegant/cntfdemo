resource "aws_service_discovery_service" "app" {
  name = "${var.resource_id}-ecs-service"

  dns_config {
    namespace_id = var.sd_ns_common_id

    dns_records {
      ttl  = 60
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
}
