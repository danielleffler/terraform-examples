#
# Security Groups
#

resource "aws_security_group" "apps-cluster" {
  name        = "terraform-eks-apps-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-apps"
  }
}

resource "aws_security_group_rule" "apps-cluster-ingress-workstation-https" {  
  cidr_blocks       = [local.workstation-external-cidr]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.apps-cluster.id
  to_port           = 443
  type              = "ingress"
}