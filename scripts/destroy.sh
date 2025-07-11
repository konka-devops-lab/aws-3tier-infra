#!/bin/bash

echo "🌍 Choose the environment to destroy:"
echo "1. development"
echo "2. production"

read -p "Enter your choice (1 or 2): " CHOICE

case "$CHOICE" in
  1)
    ENV="development"
    ;;
  2)
    ENV="production"
    ;;
  *)
    echo "❌ Invalid choice. Exiting."
    exit 1
    ;;
esac



if [ -z "$ENV" ]; then
  echo "❌ Environment not provided. Exiting."
  exit 1
fi

cd live || exit 1

# Terraform Init
echo "🔧 Initializing Terraform with backend config for $ENV..."
terraform init -backend-config=../environments/$ENV/backend.tfvars

# Terraform Plan
echo "📋 Planning Terraform changes for $ENV..."
terraform plan -var-file=../environments/$ENV/main.tfvars -destroy

# Prompt for Apply
echo "❓ Do you want to apply this plan? (yes/no)"
read CONFIRM

if [ "$CONFIRM" = "yes" ]; then
  echo "🚀 Destroy Infra ..."
  terraform destroy -var-file=../environments/$ENV/main.tfvars
else
  echo "❌ destroy cancelled."
  exit 0
fi