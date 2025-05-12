variable "environment" {
  type        = string
  description = "Environment name"
}
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
  description = "List of private subnet IDs"
}

variable "eks_nodes_security_group_id" {
  type        = string
  description = "Security group ID for EKS nodes"
}

variable "rds_instance_count" {
  type        = number
  description = "Number of RDS instances to create"
  default     = 1
}

variable "rds_instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "rds_allocated_storage" {
  type        = number
  description = "Allocated storage for RDS in GB"
}

variable "rds_engine_version" {
  type        = string
  description = "PostgreSQL version for RDS"
}

variable "rds_backup_retention" {
  type        = number
  description = "Backup retention period in days"
}

variable "rds_multi_az" {
  type        = bool
  description = "Enable multi-AZ deployment"
  default     = false
}

variable "database_username" {
  type        = string
  description = "Database username"
}

variable "database_name" {
  type        = string
  description = "Database name"
}

# variable "databases" {
#   type = map(object({
#     name     = string
#     username = string
#     password = string
#   }))
#   description = "Map of databases to create in RDS instance"
#   default     = {}
# }
