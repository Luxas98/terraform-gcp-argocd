terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket  = "terraform-states"
    prefix  = "terraform/argocd-project-state"
  }
}
