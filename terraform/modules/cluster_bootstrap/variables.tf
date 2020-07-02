variable "kes_namespace" {
  default     = "kes"
  type        = string
  description = "namespace to install KES in"
}

variable "argocd_role_arn" {
  type        = string
  description = "arn to annotate argocd pods to access kes"
}

variable "module_depends_on" {
  default = [""]
}