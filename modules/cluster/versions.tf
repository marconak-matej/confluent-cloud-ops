terraform {
  required_version = ">= 1.13.5" # Using the latest version as of November 2025

  required_providers {
    confluent = {
      source = "confluentinc/confluent"
    }
  }
}