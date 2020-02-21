#!/usr/bin/env bash
PROJECT_ID=${PROJECT_ID:=$1}
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}
terraform init
terraform destroy -var="admin_project_id=${PROJECT_ID}" -var="region=${REGION}" -var="zone=${ZONE}"
