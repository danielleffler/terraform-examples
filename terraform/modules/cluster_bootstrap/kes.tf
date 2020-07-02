resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

resource "null_resource" "kes_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/kes-namespace.yaml"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.module_depends_on]
}

// install chart in local path, the path exists outside the tf module and is part of the repository
resource "null_resource" "kes_install" {
  provisioner "local-exec" {
    command = <<EOT
    helm repo add external-secrets https://godaddy.github.io/kubernetes-external-secrets/
    helm repo update
    helm install external-secrets/kubernetes-external-secrets --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${var.argocd_role_arn} --set securityContext."fsGroup"=65534 --set kes.namespace=kes --version 4.0.0 --generate-name -n kes
    EOT
  }
  depends_on = [null_resource.kes_namespace]
}

// KES CRD appears to be installed by the controller, wait until it is up and CRD is available
resource "null_resource" "wait_for_kes_crd" {
  provisioner "local-exec" {
    command = "until kubectl get crd |grep externalsecrets.kubernetes-client.io; do echo Kubernetes External Secrets CRD not yet available; sleep 5; done"
  }
  depends_on = [null_resource.kes_install]
}