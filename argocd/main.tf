provider "google-beta" {
  alias = "ci-cd"
  region = "${var.region}"
  project = "${var.admin_project_id}"
}

provider "google-beta" {
  project = "${var.admin_project_id}"
}

provider "kubernetes" {
  alias = "ci-cd"
  host = "${google_container_cluster.ci-cd.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.ci-cd.master_auth[0].cluster_ca_certificate)
}