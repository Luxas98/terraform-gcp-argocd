#!/usr/bin/env bash
TF_ADMIN=${TF_ADMIN}
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}
APPLICATION_NAME=${APPLICATION_NAME:=$1}
CLIENT_NAME=${CLIENT_NAME:=$2}
CLUSTER_ENDPOINT=${CLUSTER_ENDPOINT:=$3}

terraform init
terraform workspace new ${CLIENT_NAME} || terraform workspace select ${CLIENT_NAME}
terraform apply -var="region=${REGION}" -var="zone=${ZONE}" -var="admin_project_id=${TF_ADMIN}" -var="overlay=${CLIENT_NAME}" -var="application_name=${APPLICATION_NAME}" -var="cluster_endpoint=${CLUSTER_ENDPOINT}"