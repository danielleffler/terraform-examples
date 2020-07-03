resource "null_resource" "argo_namespace" {
  provisioner "local-exec" {
    command = "kubectl create ns argo || true"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [null_resource.module_depends_on]
}

// use helm to install argocd, secrets, and initial app-of-apps application
resource "null_resource" "argo_install" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/stable/manifests/namespace-install.yaml
    kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=argo:default -n argo 
    kubectl annotate serviceaccount -n argo default eks.amazonaws.com/role-arn=${var.argo_workflows_role_arn} --overwrite
    EOT
  }
  //
  depends_on = [null_resource.argo_namespace, null_resource.wait_for_kes_crd]
}