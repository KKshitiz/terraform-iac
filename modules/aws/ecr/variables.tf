variable "environment" {
  type        = string
  description = "Environment name"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "repository_names" {
  type        = list(string)
  description = "List of ECR repository names to create"
}

variable "image_retention_count" {
  type        = number
  description = "Number of images to keep per repository"
  default     = 30
}