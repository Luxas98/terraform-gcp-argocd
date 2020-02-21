output "argocd-cd-cluster-name" {
  value = "${google_container_cluster.ci-cd.name}"
}

output "argcdcd-cluster-endpoint" {
  value = "${google_container_cluster.ci-cd.endpoint}"
}

output "argocd-cluster-ca" {
  value = "${google_container_cluster.ci-cd.master_auth[0].cluster_ca_certificate}"
  sensitive = true
}

output "argocd-project-id" {
  value = "${var.admin_project_id}"
}