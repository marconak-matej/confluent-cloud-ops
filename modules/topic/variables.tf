# Topic Module - variables.tf

variable "name" {
  description = "Topic name (without prefix)"
  type        = string
}

variable "team" {
  description = "Team name (used as prefix)"
  type        = string
}

variable "cluster" {
  description = "Cluster configuration object"
  type = object({
    environment_id = string # Confluent environment ID
    id             = string # Kafka cluster ID
    api_key        = string # Cluster admin API key (sensitive)
    api_secret     = string # Cluster admin API secret (sensitive)
    rest_endpoint  = string # Cluster REST endpoint
  })
}

variable "topic_config" {
  description = "Topic configuration"
  type = object({
    partitions     = number # Number of partitions (default: 6)
  })
  default = {
    partitions     = 6
  }
}

variable "readers" {
  description = "List of readers"
  type = list(object({
    service_account_id = string # SA ID
    group_id           = string # Consumer group ID
  }))
  default = []
}

variable "writers" {
  description = "List of writers"
  type = list(object({
    service_account_id = string # SA ID
  }))
  default = []
}
