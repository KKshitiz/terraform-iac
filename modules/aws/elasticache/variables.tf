variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
}
variable "environment" {
  type        = string
  description = "Environment"
}
