variable "environment" {
  type        = string
  description = "Environment name"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "domain_names" {
  type        = list(string)
  description = "List of domain names to manage"
}

variable "cloud_provider" {
  type        = string
  description = "Cloud provider (aws, azure, gcp)"
  validation {
    condition     = contains(["aws", "azure", "gcp"], var.cloud_provider)
    error_message = "Valid values for cloud_provider are: aws, azure, gcp"
  }
}

# AWS-specific variables
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = ""
}

variable "aws_oidc_provider_arn" {
  type        = string
  description = "EKS OIDC Provider ARN"
  default     = ""
}

variable "aws_oidc_provider_url" {
  type        = string
  description = "EKS OIDC Provider URL"
  default     = ""
}

# Azure-specific variables
variable "azure_resource_group_name" {
  type        = string
  description = "Azure resource group name"
  default     = ""
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default     = ""
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant ID"
  default     = ""
}

# GCP-specific variables
variable "gcp_project" {
  type        = string
  description = "GCP project ID"
  default     = ""
}
