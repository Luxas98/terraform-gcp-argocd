#!/usr/bin/env bash
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}
APPLICATION_NAME=${APPLICATION_NAME:=$1}
CLIENT_NAME=${CLIENT_NAME:=$2}
CLUSTER_ENDPOINT=${CLUSTER_ENDPOINT:=$3}
ARGOCD_PROJECT_ID=${ARGOCD_PROJECT_ID:=$4}

cd argocd-app-deploy
terraform init
terraform workspace new ${CLIENT_NAME} || terraform workspace select ${CLIENT_NAME}
terraform apply -var="region=${REGION}" -var="zone=${ZONE}" -var="admin_project_id=${ARGOCD_PROJECT_ID}" -var="overlay=${CLIENT_NAME}" -var="application_name=${APPLICATION_NAME}" -var="cluster_endpoint=${CLUSTER_ENDPOINT}"

cd ..