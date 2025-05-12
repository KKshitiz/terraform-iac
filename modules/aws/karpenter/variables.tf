# variables.tf
# Input variables for karpenter module
variable "environment" {
  type        = string
  description = "Environment name (non-prod or prod)"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider URL"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "v0.36.1"
}

variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  description = "Name of your EKS cluster"
}

