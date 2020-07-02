resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region us-west-2 update-kubeconfig --name ${var.cluster-name}"
  }
  // terraform hack to make this module wait until prerequisite modules are complete
  depends_on = [aws_eks_cluster.apps, aws_eks_node_group.demo]
}

// Install and confgure KES and Argo CD
module "cluster_bootstrap" {
  source = "./modules/cluster_bootstrap"
  argocd_role_arn = aws_iam_role.argocd.arn
  module_depends_on = [null_resource.kubectl]
}