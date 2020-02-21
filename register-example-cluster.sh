#!/usr/bin/env bash
# Exit if anycommand fails
set -e
CLIENT_NAME=${CLIENT_NAME:=$1}
ARGOCD_PROJECT_ID=${ARGOCD_PROJECT_ID:=$2}
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}


cd gcp-cluster-example
terraform workspace select ${CLIENT_NAME}

TARGET_CLUSTER_CA=$(terraform output primary_cluster_ca)
TARGET_CLUSTER_ENDPOINT=$(terraform output primary_cluster_endpoint)
TARGET_CLUSTER_TOKEN=$(terraform output primary_cluster_token)

cd ../argocd-register-k8s-cluster
terraform workspace new ${CLIENT_NAME} || terraform workspace select ${CLIENT_NAME}
terraform apply -var="admin_project_id=${ARGOCD_PROJECT_ID}" -var="region=${REGION}" -var="zone=${ZONE}" -var="target_cluster_endpoint=${TARGET_CLUSTER_ENDPOINT}" -var="target_cluster_ca=${TARGET_CLUSTER_CA}" -var="target_cluster_name=${TARGET_CLUSTER_ENDPOINT}" -var="target_sa_token=${TARGET_CLUSTER_TOKEN}"

cd ..