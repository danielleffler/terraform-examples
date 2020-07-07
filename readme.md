# Example applicaton

This code base is to demonstrate the automated provisioning of an application complete with ArgoCD for continuous deployment using GitOps.

This plan will create an EKS cluster, Network Load Balancer, DNS resolution and bootstrap the cluster with NGINX ingress controller, Cert Manager, External Secrets, ArgoCD and Argo Workflows.

Installation
 - AWS credentials are required to be located in ~/.aws/credentials
 - Modify terraform.tfvars
 
```sh
$ cd terraform
$ terraform init
$ terraform apply
```
 - After plan has complete, get nameservers and add to your domain registrar.
 - Run the following script to update ArgoCD password
```sh
$ ./reset-argocd-password.sh
```
 - login at argocd.{your_domain}