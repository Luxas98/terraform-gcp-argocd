resource "google_compute_global_address" "argocd-ip" {
  name = "argocd-ip"
  project = "${var.admin_project_id}"
  depends_on = [google_project_service.compute-service]
}


// Changes current context, so dont forget about it
resource "null_resource" "configure_kubectl" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials ${google_container_cluster.ci-cd.name} --region ${var.region}-${var.zone} --project ${var.admin_project_id}"
  }

  depends_on = [google_container_node_pool.ci-cd-pool]
}

resource "null_resource" "deploy-argocd" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kustomize build base |  kubectl apply -f -"
  }

  depends_on = [null_resource.configure_kubectl]
}