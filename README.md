# confluent-cloud-ops

Terraform-based operational management for Confluent Cloud infrastructure, including service accounts, clusters, topics, and ACLs.

## Project Structure

- **environments/dev**: Contains Terraform configurations for the development environment.
  - `dev.tfplan`: Terraform plan file for the development environment.
  - `main.tf`: Main Terraform configuration file.
  - `providers.tf`: Provider configurations.
  - `team-notifications.tf`: Notification configurations for the team.
  - `variables.tf`: Variable definitions.
  - `versions.tf`: Terraform version constraints.
- **modules**: Reusable Terraform modules.
  - `cluster`: Manages Confluent Cloud clusters.
  - `service-identity`: Handles service account identities.
  - `topic`: Manages Kafka topics.
- **scripts**: Contains deployment scripts.
  - `deploy-dev.sh`: Script to deploy the development environment.

## Prerequisites

- **Terraform**: Install [Terraform](https://www.terraform.io/downloads.html) (version >= 1.0.0).
- **Confluent Cloud Credentials**: Ensure you have API keys and secrets for Confluent Cloud.
- **Shell Access**: Use a Unix-based shell (e.g., zsh, bash).

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd confluent-cloud-ops
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Configure variables in `environments/dev/variables.tf` as needed.

## Deployment Instructions

1. Plan the deployment:
   ```bash
   terraform plan -out=dev.tfplan
   ```
2. Apply the deployment:
   ```bash
   terraform apply dev.tfplan
   ```
3. Alternatively, use the deployment script:
   ```bash
   ./scripts/deploy-dev.sh
   ```

## Additional Notes

- Ensure your Confluent Cloud credentials are securely stored and not hardcoded.
- Review the `outputs.tf` files in each module for available outputs.
- For production environments, create a separate directory under `environments/` and replicate the structure of `dev/`.
