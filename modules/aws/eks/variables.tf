variable "environment" {
  type        = string
  description = "Environment name (non-prod or prod)"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs"
}

variable "eks_nodes_security_group_id" {
  type        = string
  description = "Security group ID for EKS nodes"
}

variable "on_demand_node_group_config" {
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
    instance_types = list(string)
  })
  description = "On-demand node group configuration"
}

variable "spot_node_group_config" {
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
    instance_types = list(string)
  })
  description = "Spot node group configuration"
}
