#!/usr/bin/env bash
# Exit if anycommand fails
set -e
CLIENT_NAME=${CLIENT_NAME:=$1}
PROJECT_ID=${PROJECT_ID:=$2}
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}

# Create or select terraform workspace
terraform init
terraform workspace new ${CLIENT_NAME} || terraform workspace select ${CLIENT_NAME}
terraform apply -var="project_id=${PROJECT_ID}" -var="region=${REGION}" -var="zone=${ZONE}"