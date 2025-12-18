# Dev Environment - main.tf

module "cluster" {
  source = "../../modules/cluster"

  environment_name = "dev"
  cluster_config = {
    name           = "mm-cluster"
    cloud_provider = "AWS"
    region         = "us-east-2"
    availability   = "SINGLE_ZONE"
    type           = "STANDARD"
  }
}

