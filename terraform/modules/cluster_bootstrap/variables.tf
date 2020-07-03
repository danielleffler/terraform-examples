variable "kes_namespace" {
  default     = "kes"
  type        = string
  description = "namespace to install KES in"
}

variable "argocd_role_arn" {
  type        = string
  description = "arn to annotate argocd pods to access kes"
}

variable "argo_workflows_role_arn" {
  type        = string
  description = "arn to annotate argo pods to access kes and s3 buckets"
}

variable "module_depends_on" {
  default = [""]
}