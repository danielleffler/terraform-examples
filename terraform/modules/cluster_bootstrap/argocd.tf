resource "null_resource" "argocd_namespace" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/files/argocd-namespace.yaml"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.module_depends_on]
}

// use helm to install argocd, secrets, and initial app-of-apps application
resource "null_resource" "argocd_install" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    EOT
  }
  depends_on = [null_resource.argocd_namespace, null_resource.wait_for_kes_crd]
}

resource "null_resource" "wait_for_argocd" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n argocd --timeout=300s
    EOT
  }
  depends_on = [null_resource.argocd_install]
}

resource "null_resource" "patch_argocd_install" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl patch deployment argocd-server --type json -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]' -n argocd
    EOT
  }
  depends_on = [null_resource.argocd_namespace, null_resource.wait_for_argocd]
}