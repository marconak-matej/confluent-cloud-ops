# Dev Environment - team-notifications.tf

locals {
  team_notifications_name = "team-notifications"
}

module "team_notifications-service-identity" {
  source = "../../modules/service-identity"

  cluster = module.cluster.cluster
  identity = {
    team        = local.team_notifications_name
    name        = "sa-notify-engine",
    description = "Service account responsible for notify engine"
  }
}

module "team_notifications-topic" {
  source = "../../modules/topic"

  name    = "notify-engine"
  team    = local.team_notifications_name
  cluster = module.cluster.cluster
  topic_config = {
    partitions     = 1
    retention_ms   = 604800000
    cleanup_policy = "delete"
  }
  readers = [{
    service_account_id = module.team_notifications-service-identity.service_account_id
    group_id           = "notify-engine-group"
    }
  ]
  writers = [{
    service_account_id = module.team_notifications-service-identity.service_account_id
    }
  ]
}
