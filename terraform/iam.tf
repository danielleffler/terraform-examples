#
# IAM Roles
#

resource "aws_iam_role" "apps-cluster" {
  name = "terraform-eks-apps-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "apps-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.apps-cluster.name
}

resource "aws_iam_role_policy_attachment" "apps-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.apps-cluster.name
}


resource "aws_iam_role" "apps-node" {
  name = "terraform-eks-apps-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "apps-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.apps-node.name
}

resource "aws_iam_role_policy_attachment" "apps-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.apps-node.name
}

resource "aws_iam_role_policy_attachment" "apps-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.apps-node.name
}

data "external" "thumbprint" {
  program = ["bash", "${path.module}/thumbprint.sh", data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "apps" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = "${aws_eks_cluster.apps.identity.0.oidc.0.issuer}"
  depends_on = [aws_eks_cluster.apps]
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "apps_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.apps.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:*"]
    }

    principals {
      identifiers = ["${aws_iam_openid_connect_provider.apps.arn}"]
      type        = "Federated"
    }
  }
  depends_on = [aws_iam_openid_connect_provider.apps]
}

resource "aws_iam_role" "argocd" {
  assume_role_policy = "${data.aws_iam_policy_document.apps_assume_role_policy.json}"
  name               = "argocd-role"
}

resource "aws_iam_role_policy_attachment" "app-role-Secrets_Manager_Read_Write" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.argocd.name
}

resource "aws_iam_role" "argo-workflows" {
  assume_role_policy = "${data.aws_iam_policy_document.apps_assume_role_policy.json}"
  name               = "argo-workflows-role"
}

resource "aws_iam_policy" "argo-workflows" {
  name        = "argo-workflows-policy"
  description = "Allow access to artifacts"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetBucketLocation"
      ],
      "Effect": "Allow",
      "Resource":"${aws_s3_bucket.argo-workflow-artifacts.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "argo-workflows-attach" {
  role       = "${aws_iam_role.argo-workflows.name}"
  policy_arn = "${aws_iam_policy.argo-workflows.arn}"
}