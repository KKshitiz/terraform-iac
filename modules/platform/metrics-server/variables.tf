# variables.tf
# Input variables for metrics-server module

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy metrics-server to"
  default     = "kube-system"
}

variable "chart_version" {
  type        = string
  description = "Version of metrics-server to deploy"
  default     = "3.11.0"
}
