# Topic Module - outputs.tf

output "topic_name" {
  description = "Full topic name with prefix"
  value       = local.topic_name
}

output "topic_id" {
  description = "Topic resource ID"
  value       = confluent_kafka_topic.this.id
}

output "partitions" {
  description = "Number of partitions"
  value       = confluent_kafka_topic.this.partitions_count
}

output "topic" {
  description = "Complete topic object with name, id, and configuration"
  value = {
    name       = local.topic_name
    id         = confluent_kafka_topic.this.id
    partitions = confluent_kafka_topic.this.partitions_count
    config     = var.topic_config
  }
}
