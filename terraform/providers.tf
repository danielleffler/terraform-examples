#
# Provider Configuration
#

provider "aws" {
  region  = "us-west-2"
  version = ">= 2.38.0"
  shared_credentials_file = "/Users/danielleffler/.aws/credentials"
  profile  = "default"
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# Not required: currently used in conjuction with using
# icanhazip.com to determine local workstation external IP
# to open EC2 Security Group access to the Kubernetes cluster.
# See workstation-external-ip.tf for additional information.
provider "http" {}

provider "external" {}

provider "kubernetes" {
  host                   = "${aws_eks_cluster.apps.endpoint}"
  cluster_ca_certificate = "${base64decode(aws_eks_cluster.apps.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.apps.token}"
  load_config_file       = false
}

data "aws_eks_cluster_auth" "apps" {
  name = aws_eks_cluster.apps.name
  depends_on = [aws_eks_cluster.apps]
}