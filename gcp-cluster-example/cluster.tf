resource "google_container_cluster" "primary" {
  provider = "google-beta"
  name     = "${var.project_id}"
  location = "${var.region}-${var.zone}"
  project = "${var.project_id}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = true
    }
  }

  resource_usage_export_config {
    enable_network_egress_metering = false
    bigquery_destination {
      dataset_id = "${google_bigquery_dataset.cluster-usage-dataset.dataset_id}"
    }
  }

  # This enables IP-aliasing
  ip_allocation_policy {}

  depends_on = [google_bigquery_dataset.cluster-usage-dataset]
}

resource "google_container_node_pool" "service-pool" {
  name       = "service-pool"
  location   = "${var.region}-${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  initial_node_count = 1
  project = "${var.project_id}"

  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }

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
}

resource "google_container_node_pool" "ml-pool" {
  provider = "google-beta"
  name       = "ml-pool"
  location   = "${var.region}-${var.zone}"
  cluster    = "${google_container_cluster.primary.name}"
  initial_node_count = 0
  project = "${var.project_id}"

  autoscaling {
    min_node_count = 0
    max_node_count = 8
  }

  management {
    auto_upgrade = false
  }

  node_config {
    preemptible  = false
    machine_type = "c2-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      ml-workloads = "true"
    }

    taint {
      effect = "NO_SCHEDULE"
      key = "ml-workloads"
      value = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}