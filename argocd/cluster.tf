resource "google_container_cluster" "ci-cd" {
  provider = "google-beta"
  name = "${var.admin_project_id}"
  location = "${var.region}-${var.zone}"
  project = "${var.admin_project_id}"

  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  # This enables IP-aliasing
  ip_allocation_policy {}

  resource_usage_export_config {
    enable_network_egress_metering = false
    bigquery_destination {
      dataset_id = "${google_bigquery_dataset.cluster-usage-dataset.dataset_id}"
    }
  }

  depends_on = [google_bigquery_dataset.cluster-usage-dataset]
}

resource "google_container_node_pool"  "ci-cd-pool" {
  project = "${var.admin_project_id}"
  name = "main"
  location = google_container_cluster.ci-cd.location
  cluster = google_container_cluster.ci-cd.name
  node_count = 1

  management {
    auto_upgrade = false
  }

  node_config {
    preemptible  = false
    machine_type = "c2-standard-4"
    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  depends_on = [google_container_cluster.ci-cd]
}

resource "google_bigquery_dataset" "cluster-usage-dataset" {
  project = var.admin_project_id
  dataset_id                  = "gke_resource_metrics"
  friendly_name               = "Resource metrics"
  description                 = "Cluster usage metrics"
  location                    = "EU"

  access {
    role          = "OWNER"
    user_by_email = "terraform@admin.iam.gserviceaccount.com"
  }

  depends_on = [google_project_service.bigquery-service]
}

