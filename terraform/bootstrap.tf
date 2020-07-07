// Install and confgure KES Argo, Argo CD
module "cluster_bootstrap" {
  source = "./modules/cluster_bootstrap"
  argocd_role_arn = aws_iam_role.argocd.arn
  argo_workflows_role_arn = aws_iam_role.argo-workflows.arn
  module_depends_on = [null_resource.nginx_ingress_install]
}