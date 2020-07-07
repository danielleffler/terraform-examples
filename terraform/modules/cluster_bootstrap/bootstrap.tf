resource "null_resource" "bootstrap" {
  provisioner "local-exec" {
    command = <<EOT
    helm template ${path.module}/../../../argocd --generate-name | kubectl apply -f -
    EOT
  }

  depends_on = [null_resource.module_depends_on, null_resource.wait_for_kes_crd, null_resource.wait_for_cert_manager, null_resource.wait_for_argocd, null_resource.argo_install]
}