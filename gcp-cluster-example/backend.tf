terraform {
  required_version = ">= 0.12"
  backend "gcs" {
    bucket  = "ci-cd-241510-terraform-states"
    prefix  = "terraform/cluster-state"
  }
}
