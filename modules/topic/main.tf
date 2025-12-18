# Topic Module - main.tf

locals {
  topic_name = "${var.team}.${var.name}"
  readers_map = {
    for r in var.readers : "${r.service_account_id}-${r.group_id}" => r
  }

  writers_map = {
    for w in var.writers : w.service_account_id => w
  }
}

resource "confluent_kafka_topic" "this" {
  kafka_cluster {
    id = var.cluster.id
  }

  topic_name       = local.topic_name
  partitions_count = var.topic_config.partitions
  # config        = var.topic_config
  rest_endpoint = var.cluster.rest_endpoint
  credentials {
    key    = var.cluster.api_key
    secret = var.cluster.api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "reader" {
  for_each = local.readers_map
  kafka_cluster {
    id = var.cluster.id
  }
  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.this.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${each.value.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.cluster.rest_endpoint
  credentials {
    key    = var.cluster.api_key
    secret = var.cluster.api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "reader-group" {
  for_each = local.readers_map

  kafka_cluster {
    id = var.cluster.id
  }

  resource_type = "GROUP"
  resource_name = each.value.group_id
  pattern_type  = "PREFIXED"
  principal     = "User:${each.value.service_account_id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = var.cluster.rest_endpoint
  credentials {
    key    = var.cluster.api_key
    secret = var.cluster.api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_kafka_acl" "writer" {
  for_each = local.writers_map

  kafka_cluster {
    id = var.cluster.id
  }

  resource_type = "TOPIC"
  resource_name = confluent_kafka_topic.this.topic_name
  pattern_type  = "LITERAL"
  principal     = "User:${each.value.service_account_id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = var.cluster.rest_endpoint
  credentials {
    key    = var.cluster.api_key
    secret = var.cluster.api_secret
  }

  lifecycle {
    prevent_destroy = true
  }
}

