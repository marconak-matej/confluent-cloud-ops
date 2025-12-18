# Cluster Module - main.tf

# Create environment
resource "confluent_environment" "this" {
  display_name = var.environment_name
}

# Create cluster
resource "confluent_kafka_cluster" "this" {
  display_name = var.cluster_config.name
  availability = var.cluster_config.availability
  cloud        = var.cluster_config.cloud_provider
  region       = var.cluster_config.region

  # Dynamic block based on cluster type
  dynamic "basic" {
    for_each = var.cluster_config.type == "BASIC" ? [1] : []
    content {}
  }

  dynamic "standard" {
    for_each = var.cluster_config.type == "STANDARD" ? [1] : []
    content {}
  }

  dynamic "dedicated" {
    for_each = var.cluster_config.type == "DEDICATED" ? [1] : []
    content {
      cku = var.cluster_config.cku
    }
  }

  environment {
    id = confluent_environment.this.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Create cluster admin service account
resource "confluent_service_account" "cluster_admin" {
  display_name = "${var.cluster_config.name}-admin"
  description  = "Cluster admin for ${var.cluster_config.name}"

  lifecycle {
    prevent_destroy = true
  }
}

# Grant CloudClusterAdmin role to the service account
resource "confluent_role_binding" "cluster_admin" {
  principal   = "User:${confluent_service_account.cluster_admin.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.this.rbac_crn

  lifecycle {
    prevent_destroy = true
  }
}

# Create Kafka API key for the cluster admin
resource "confluent_api_key" "cluster_admin" {
  display_name = "${var.cluster_config.name}-admin-kafka-key"
  description  = "Kafka API key for ${var.cluster_config.name} admin"

  owner {
    id          = confluent_service_account.cluster_admin.id
    api_version = confluent_service_account.cluster_admin.api_version
    kind        = confluent_service_account.cluster_admin.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.this.id
    api_version = confluent_kafka_cluster.this.api_version
    kind        = confluent_kafka_cluster.this.kind

    environment {
      id = confluent_environment.this.id
    }
  }

  depends_on = [confluent_role_binding.cluster_admin]

  lifecycle {
    prevent_destroy = true
  }
}
