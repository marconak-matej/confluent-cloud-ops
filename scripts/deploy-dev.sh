#!/bin/bash
set -e

ENV="dev"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ENV_DIR="${SCRIPT_DIR}/../environments/${ENV}"

echo "🚀 Deploying Confluent infrastructure to ${ENV} environment..."
echo ""

# Check if we're in the right directory
if [ ! -d "${ENV_DIR}" ]; then
  echo "❌ Error: Environment directory ${ENV_DIR} not found"
  exit 1
fi

cd "${ENV_DIR}"

# Check for required environment variables
if [ -z "$TF_VAR_confluent_cloud_api_key" ] || [ -z "$TF_VAR_confluent_cloud_api_secret" ]; then
  echo "⚠️  Warning: Confluent API credentials not set in environment variables"
  echo "Please set:"
  echo "  export TF_VAR_confluent_cloud_api_key='your-api-key'"
  echo "  export TF_VAR_confluent_cloud_api_secret='your-api-secret'"
  echo ""
  echo "Or create a terraform.tfvars file with the credentials"
  echo ""
  exit 1
fi

# Initialize Terraform
echo "📦 Initializing Terraform..."
terraform init -upgrade

# Format check
echo "🎨 Checking Terraform formatting..."
terraform fmt -check -recursive || {
  echo "⚠️  Formatting issues found. Run 'terraform fmt -recursive' to fix."
}

# Validate configuration
echo "✅ Validating Terraform configuration..."
terraform validate

# Plan changes
echo ""
echo "📋 Planning infrastructure changes..."
terraform plan -out="${ENV}.tfplan"

# Prompt for approval
echo ""
echo "═══════════════════════════════════════════════════════"
echo "Review the plan above carefully."
echo "═══════════════════════════════════════════════════════"
echo ""
read -p "Do you want to apply these changes? (yes/no): " -r
echo ""

if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
  echo "🚀 Applying changes..."
  terraform apply "${ENV}.tfplan"

  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "✅ Deployment to ${ENV} environment complete!"
  echo "═══════════════════════════════════════════════════════"
  echo ""
  echo "📊 Outputs:"
  terraform output
else
  echo "❌ Deployment cancelled"
  rm -f "${ENV}.tfplan"
  exit 0
fi

