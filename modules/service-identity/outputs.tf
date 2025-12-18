# Service Identity Module - outputs.tf

output "service_account_id" {
  description = "Service account ID"
  value       = confluent_service_account.this.id
}

output "service_account_name" {
  description = "Service account display name"
  value       = confluent_service_account.this.display_name
}

output "identity" {
  description = "Complete identity object with service account and API key details"
  sensitive   = true
  value = {
    service_account_id   = confluent_service_account.this.id
    service_account_name = confluent_service_account.this.display_name
    kafka_api_key_id     = var.create_kafka_api_key ? confluent_api_key.kafka[0].id : null
    kafka_api_key_secret = var.create_kafka_api_key ? confluent_api_key.kafka[0].secret : null
  }
}
