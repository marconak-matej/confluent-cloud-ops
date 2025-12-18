# Service Identity Module - main.tf

locals {
  display_name = "${var.identity.team}-${var.identity.name}"
  description  = var.identity.description != "" ? var.identity.description : "Service account for ${var.identity.team} team: ${var.identity.name}"
}

# Create service account
resource "confluent_service_account" "this" {
  display_name = local.display_name
  description  = local.description

  lifecycle {
    prevent_destroy = true
  }
}

# Create Kafka API key (optional)
resource "confluent_api_key" "kafka" {
  count = var.create_kafka_api_key ? 1 : 0

  display_name = "${local.display_name}-kafka-key"
  description  = "Kafka API key for ${local.display_name}"

  owner {
    id          = confluent_service_account.this.id
    api_version = confluent_service_account.this.api_version
    kind        = confluent_service_account.this.kind
  }

  managed_resource {
    id          = var.cluster.id
    api_version = var.cluster.api_version
    kind        = var.cluster.kind

    environment {
      id = var.cluster.environment_id
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
