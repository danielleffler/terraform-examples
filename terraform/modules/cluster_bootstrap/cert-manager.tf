resource "null_resource" "cert_manager_install" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl create namespace cert-manager || true
    kubectl label namespace cert-manager cert-manager.k8s.io/disable-validation=true
    kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml
    EOT
  }

  depends_on = [null_resource.module_depends_on, null_resource.wait_for_kes_crd]
}

resource "null_resource" "wait_for_cert_manager" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl wait --for=condition=available deployment cert-manager-webhook -n cert-manager --timeout=300s
    EOT
  }
  depends_on = [null_resource.cert_manager_install]
}