# Example applicaton

This code base is to demonstrate the automated provisioning of an application on AWS complete with ArgoCD for continuous deployment using GitOps.

This plan will create an EKS cluster, Network Load Balancer, DNS resolution and bootstrap the cluster with NGINX ingress controller, Cert Manager, External Secrets, ArgoCD and Argo Workflows.
 
Todos
 - Add CI with Argo Workflows and Events