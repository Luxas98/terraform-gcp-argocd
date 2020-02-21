provider "google-beta" {
  alias = "ci-cd"
  credentials = file("../ci-cd-admin.json")
  region = var.region
  project = var.admin_project_id
}

data "google_container_cluster" "ci-cd" {
  provider = google-beta.ci-cd
  name = var.admin_project_id
  location = "${var.region}-${var.zone}"
}

provider "kubernetes" {
  alias = "ci-cd"
  host = data.google_container_cluster.ci-cd.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.ci-cd.master_auth[0].cluster_ca_certificate)
}

provider "kubernetes" {
  alias = "primary"
  host = "https://${var.target_cluster_endpoint}"
//  cluster_ca_certificate = var.target_cluster_ca
  token = var.target_sa_token
  load_config_file = false
  insecure = true # TODO: fix this, we need certs for nginx - x509: cannot validate certificate for 34.90.145.245 because it doesn't contain any IP SANs
}