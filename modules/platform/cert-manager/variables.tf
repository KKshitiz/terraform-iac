variable "environment" {
  type        = string
  description = "Environment name"
}
variable "namespace" {
  type        = string
  description = "Namespace to deploy cert-manager to"
  default     = "cert-manager"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "1.17.0"
}


variable "acme_email" {
  description = "Email address for ACME certificates (Let's Encrypt)"
  type        = string
}
