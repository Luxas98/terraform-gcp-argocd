output "argocd-admin-ca" {
  value = "${data.kubernetes_secret.argocd-admin-token.data["ca.crt"]}"
}

output "argocd-admin-token" {
  value = "${data.kubernetes_secret.argocd-admin-token.data["token"]}"
}

output "admin-credentials" {
  value = file("../ci-cd-admin.json")
}