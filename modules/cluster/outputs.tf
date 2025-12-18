# Cluster Module - outputs.tf

output "environment_id" {
  description = "Confluent environment ID"
  value       = confluent_environment.this.id
}

output "environment_name" {
  description = "Environment display name"
  value       = confluent_environment.this.display_name
}

output "cluster_id" {
  description = "Kafka cluster ID"
  value       = confluent_kafka_cluster.this.id
}

output "cluster_name" {
  description = "Cluster display name"
  value       = confluent_kafka_cluster.this.display_name
}

output "cluster_bootstrap_endpoint" {
  description = "Kafka bootstrap endpoint"
  value       = confluent_kafka_cluster.this.bootstrap_endpoint
}

output "cluster_rest_endpoint" {
  description = "Kafka REST endpoint"
  value       = confluent_kafka_cluster.this.rest_endpoint
}

output "cluster_admin_api_key" {
  description = "Cluster admin API key ID"
  value       = confluent_api_key.cluster_admin.id
}

output "cluster_admin_api_secret" {
  description = "Cluster admin API secret"
  sensitive   = true
  value       = confluent_api_key.cluster_admin.secret
}

output "environment" {
  description = "Environment object with id and name"
  value = {
    id   = confluent_environment.this.id
    name = confluent_environment.this.display_name
  }
}

output "cluster" {
  description = "Complete cluster configuration object for passing to other modules"
  sensitive   = true
  value = {
    environment_id = confluent_environment.this.id
    id             = confluent_kafka_cluster.this.id
    api_key        = confluent_api_key.cluster_admin.id
    api_secret     = confluent_api_key.cluster_admin.secret
    rest_endpoint  = confluent_kafka_cluster.this.rest_endpoint
    api_version    = confluent_kafka_cluster.this.api_version
    kind           = confluent_kafka_cluster.this.kind
  }
}

output "cluster_admin" {
  description = "Cluster admin service account and API key object"
  sensitive   = true
  value = {
    service_account_id = confluent_service_account.cluster_admin.id
    api_key            = confluent_api_key.cluster_admin.id
    api_secret         = confluent_api_key.cluster_admin.secret
  }
}
