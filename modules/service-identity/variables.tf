# Service Identity Module - variables.tf

variable "identity" {
  description = "Identity configuration object"
  type = object({
    name        = string # Service account name
    team        = string # Team name (used as prefix)
    description = string # Service account description (optional, default: "")
  })
}

variable "cluster" {
  description = "Cluster configuration object"
  sensitive   = true
  type = object({
    environment_id = string # Confluent environment ID
    id             = string # Kafka cluster ID
    api_key        = string # Cluster admin API key (sensitive)
    api_secret     = string # Cluster admin API secret (sensitive)
    api_version    = string
    kind           = string
  })
}

variable "create_kafka_api_key" {
  description = "Create Kafka API key"
  type        = bool
  default     = true
}
