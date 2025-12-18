# Cluster Module - variables.tf

variable "environment_name" {
  description = "Environment display name"
  type        = string
}

variable "cluster_config" {
  description = "Cluster configuration object"
  type = object({
    name           = string           # Kafka cluster display name
    cloud_provider = string           # Cloud provider (AWS, GCP, AZURE) - default: "AWS"
    region         = string           # Cloud region
    availability   = string           # Availability type (SINGLE_ZONE, MULTI_ZONE) - default: "SINGLE_ZONE"
    type           = string           # Cluster type (BASIC, STANDARD, DEDICATED) - default: "BASIC"
    cku            = optional(number) # CKU for dedicated cluster (required if type = DEDICATED) - default: null
  })
}
