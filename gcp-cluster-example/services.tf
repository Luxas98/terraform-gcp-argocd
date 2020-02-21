resource "google_project_service" "compute-service" {
 project = "${var.project_id}"
 service = "compute.googleapis.com"
 disable_dependent_services = false
 disable_on_destroy = false
}

resource "google_project_service" "bigquery-service" {
 project = "${var.project_id}"
 service = "bigquery.googleapis.com"
 disable_dependent_services = false
 disable_on_destroy = false
}