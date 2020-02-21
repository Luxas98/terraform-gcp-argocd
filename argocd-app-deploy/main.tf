data "template_file" "app-patch-template" {
  template = file("${path.module}/base/app-patch.tpl")
  vars = {
    cluster_endpoint = "${var.cluster_endpoint}"
    overlay = "${var.overlay}"
    app = "${var.application_name}"
  }
}

data "template_file" "kustomization-template" {
  template = file("${path.module}/base/kustomization.tpl")
  vars = {
    overlay = "${var.overlay}"
    app = "${var.application_name}"
  }
}


resource "local_file" "app-patch" {
  filename = "${path.module}/base/app-patch.yaml"
  content = "${data.template_file.app-patch-template.rendered}"
}

resource "local_file" "kustomize-patch" {
  filename = "${path.module}/base/kustomization.yaml"
  content = "${data.template_file.kustomization-template.rendered}"
}


resource "null_resource" "configure_kubectl" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials ${data.google_container_cluster.ci-cd.name} --region ${var.region}-${var.zone} --project ${var.admin_project_id}"
  }

  depends_on = [data.google_container_cluster.ci-cd]
}

resource "null_resource" "kustomize-apply-app" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kustomize build base | kubectl apply -f -"
  }

  depends_on = [local_file.kustomize-patch, null_resource.configure_kubectl]
}