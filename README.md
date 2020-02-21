[WIP] Argocd deployment and management using terraform, kustomize and bash
====================================================================

Example configuration and implementation how the deployment of argocd, 
registration of k8s clusters, projects and applications.

Requires some preexisting infrastructure on GCP:

* project where to deploy argocd
* project where to deploy gke cluster or existing gke cluster
* setup terraform for managing gcp (https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform)
* repository with manifests/kustomization files which argocd can track changes on

## Argocd

based on: https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/

Folders: 

    argocd

Script: 

    ./deploy-argocd-server.sh

Example:

    ./deploy-argocd-server.sh argocd-ci-cd-project

* To deploy argocd server, you need to configure `# FIX ME` variables, existing application repo with manifests or kustomization files is expected

* for google SSO dex secrets have to be setup

## Register gke cluster to running Argocd

Folders: 

    argocd-register-k8s-cluster
    gcp-cluster-example

Script: 

    ./deploy-example-cluster.sh
    ./register-example-cluster.sh
    
Example:
    
    ./deploy-example-cluster.sh dev-cluster project-id-123
    ./register-example-cluster.sh dev-cluster argocd-ci-cd-project
    
Register using terraform module usage:

    module "cluster-argocd-registration" {
      source = "../argocd-register-k8s-cluster"
      admin_project_id = "${var.admin_project_id}"
      region = "${var.region}"
      zone = "${var.zone}"
      target_cluster_endpoint = "${data.google_container_cluster.primary.endpoint}"
      target_cluster_ca = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
      target_cluster_name = "${data.google_container_cluster.primary.endpoint}"
      target_sa_token = "${var.primary_cluster_token}"
    }

* to add cluster where argocd can deploy applications you first need to create a gke cluster (check gcp-cluster-example)

## Add argocd project

Folders: 

    argocd-project-add
    
Scripts:

    ./deploy-argocd-project.sh
    
Example:

    ./deploy-argocd-project.sh dev-cluster argocd-ci-cd-project

* please see the structure of adding project

## Add argocd application

Folders: 

    argocd-app-deploy
    argocd-apps
    
Scripts:

    ./deploy-app.sh

Example: 
    
    ./deploy-app.sh redis dev-cluster <cluster-endpoint> argocd-ci-cd-project 
    
* deploys application from argocd-apps folder
* there is example structure for redis deployment
* the loading of the apps is expected from repository where argocd is tracking the changes