#!/usr/bin/env bash
CLIENT_NAME=${CLIENT_NAME:=$1}
CLUSTER_ENDPOINT=${CLUSTER_ENDPOINT:=$2}
REGION=${REGION:=europe-west4}
ZONE=${ZONE:=a}

cd ../argocd
terraform init
PROJECT_ID=$(terraform output argocd-project-id)

cd ../argocd-project-add
terraform init
terraform workspace new ${CLIENT_NAME} || terraform workspace select ${CLIENT_NAME}
terraform apply -var="admin_project_id=${PROJECT_ID}" -var="region=${REGION}" -var="client_name=${CLIENT_NAME}" -var="cluster_endpoint=${CLUSTER_ENDPOINT}" -var="overlay=${CLIENT_NAME}" -var="zone=${ZONE}"
#!/usr/bin/env bash