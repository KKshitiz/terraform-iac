variable "environment" {
  type        = string
  description = "Environment name"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "4.12.1"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy nginx ingress controller to"
}
