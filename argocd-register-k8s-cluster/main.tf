resource "kubernetes_service_account" "argocd-admin" {
  provider = kubernetes.primary

  metadata {
    generate_name = "argocd-admin"
    namespace = "kube-system"
  }
}

data "kubernetes_secret" "argocd-admin-token" {
  provider = kubernetes.primary

  metadata {
    name = kubernetes_service_account.argocd-admin.default_secret_name
    namespace = kubernetes_service_account.argocd-admin.metadata.0.namespace
  }

  depends_on = [kubernetes_service_account.argocd-admin]
}

resource "kubernetes_cluster_role_binding" "argocd-admin-binding" {
  provider = kubernetes.primary
  metadata {
    name = "argocd-admin-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.argocd-admin.metadata.0.name
    namespace = "kube-system"
  }
}

resource "kubernetes_secret" "cluster-secret" {
  provider = kubernetes.ci-cd

  metadata {
    name = "cluster-${var.target_cluster_name}"
    namespace = "argo-cd"
    labels = {
      "argocd.argoproj.io/secret-type": "cluster"
    }
  }

  type = "Opaque"
  data = {
    name = "cluster-${var.target_cluster_name}"
    server = "https://${var.target_cluster_endpoint}"
//    config = <<EOF
//    { "bearerToken": "${data.kubernetes_secret.argocd-admin-token.data["token"]}", "tlsClientConfig": {"insecure": false, "caData": "${base64encode(data.kubernetes_secret.argocd-admin-token.data["ca.crt"])}" }}
//    EOF
    config = <<EOF
    { "bearerToken": "${data.kubernetes_secret.argocd-admin-token.data["token"]}", "tlsClientConfig": {"insecure": true}}
    EOF
  }

  depends_on = [kubernetes_service_account.argocd-admin, kubernetes_cluster_role_binding.argocd-admin-binding]
}



