#!/usr/bin/env bash
# Exit if anycommand fails
set -e

PROJECT_ID=${PROJECT_ID:=$1}
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}
cd argocd
terraform init
terraform apply -var="admin_project_id=${PROJECT_ID}" -var="region=${REGION}" -var="zone=${ZONE}"
cd -
