variable "environment" {
  type        = string
  description = "Environment name (non-prod or prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "project_name" {
  type        = string
  description = "Project name"
}
