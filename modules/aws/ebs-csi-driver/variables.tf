variable "environment" {
  type        = string
  description = "Environment name (Used in naming resources)"
}

variable "project_name" {
  type        = string
  description = "Project name (Used in naming resources)"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy the EBS CSI driver to"
  default     = "kube-system"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "2.26.1"
}

variable "oidc_provider_arn" {
  type        = string
  description = "EKS OIDC Provider ARN"
}

variable "oidc_provider_url" {
  type        = string
  description = "EKS OIDC Provider URL"
}
