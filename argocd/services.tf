resource "google_project_service" "compute-service" {
 project = "${var.admin_project_id}"
 service = "compute.googleapis.com"
 disable_dependent_services = false
 disable_on_destroy = false
}

resource "google_project_service" "bigquery-service" {
 provider = "google-beta"
 project = var.admin_project_id
 service = "bigquery.googleapis.com"
 disable_dependent_services = false
 disable_on_destroy = false
}

resource "google_project_service" "iap-service" {
 provider = "google-beta"
 project = var.admin_project_id
 service = "iap.googleapis.com"
 disable_dependent_services = false
 disable_on_destroy = false
}