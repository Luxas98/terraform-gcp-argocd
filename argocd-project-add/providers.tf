provider "google-beta" {
  alias = "ci-cd"
  region = "${var.region}"
  project = "${var.admin_project_id}"
}

data "google_container_cluster" "ci-cd" {
  provider = "google-beta.ci-cd"
  name = "${var.admin_project_id}"
  location = "${var.region}-${var.zone}"
}


provider "kubernetes" {
  alias = "ci-cd"
  host = "${data.google_container_cluster.ci-cd.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.ci-cd.master_auth[0].cluster_ca_certificate)
}