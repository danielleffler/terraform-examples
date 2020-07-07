# Example applicaton

This code base is to demonstrate the automated provisioning of an application on AWS with ArgoCD for continuous deployment (GitOps).

The terraform plan will create an EKS cluster, Network Load Balancer, DNS resolution, OIDC Identity and bootstrap the cluster with NGINX ingress controller, Cert Manager, External Secrets, ArgoCD and Argo Workflows.

**Security Features**

Secrets are stored in AWS Secrets Manager then synchronized in cluster using Kubernetes External Secrets.  This allows secret configuration files to be stored safely in git while only referencing key pairs.

IAM Roles are created and associated with kubernetes service accounts in order for pods to access AWS APIs.  Authentication takes place against an OIDC Identity that has established trust with the cluster and specific service accounts.

**Todos**
 - Add CI with Argo Workflows and Events