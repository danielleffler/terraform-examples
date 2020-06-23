#
# EKS Cluster Resources
#  * IAM Role to allow EKS service to manage other AWS services
#  * EC2 Security Group to allow networking traffic with EKS cluster
#  * EKS Cluster
#

resource "aws_eks_cluster" "apps" {
  name     = var.cluster-name
  role_arn = aws_iam_role.apps-cluster.arn
  
  vpc_config {
    security_group_ids = [aws_security_group.apps-cluster.id]
    subnet_ids         = aws_subnet.apps[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.apps-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.apps-cluster-AmazonEKSServicePolicy,
  ]
}
