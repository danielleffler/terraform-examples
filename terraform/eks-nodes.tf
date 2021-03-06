#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.apps.name
  node_group_name = "apps-node"
  node_role_arn   = aws_iam_role.apps-node.arn
  subnet_ids      = aws_subnet.apps[*].id
  instance_types = ["t3.medium"]
  scaling_config {
    desired_size = "${var.node-count}"
    max_size     = "${var.node-count}"
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.apps-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.apps-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.apps-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
