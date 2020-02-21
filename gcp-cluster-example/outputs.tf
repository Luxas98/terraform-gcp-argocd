output "primary_cluster_name" {
 value = "${google_container_cluster.primary.name}"
}

output "primary_cluster_endpoint" {
 value = "${google_container_cluster.primary.endpoint}"
}

output "ml_pool_id" {
  value = "${google_container_node_pool.ml-pool.id}"
}

output "service_pool_id" {
  value = "${google_container_node_pool.service-pool.id}"
}

output "cluster_admin_access_token" {
  value = "${data.kubernetes_secret.cluster-admin-token.data["token"]}"
  sensitive = true
}

output "cluster_admin_ca_cert" {
  value = "${data.kubernetes_secret.cluster-admin-token.data["ca.crt"]}"
  sensitive = true
}

output "metrics_dataset_id" {
  value = google_bigquery_dataset.cluster-usage-dataset.dataset_id
}

output "primary_cluster_ca" {
  value = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  sensitive = true
}

output "primary_cluster_auth" {
  value = google_container_cluster.primary.master_auth[0]
}

output "primary_cluster_token" {
  value = data.google_client_config.cluster-token.access_token
}