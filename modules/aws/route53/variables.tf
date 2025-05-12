variable "environment" {
  type        = string
  description = "Environment name (e.g., staging, production)"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the hosted zone"
}

variable "private_zone" {
  type        = bool
  description = "Whether this is a private hosted zone"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with the private hosted zone"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS records to create"
  default     = []
}

variable "alias_records" {
  type = list(object({
    name = string
    type = string
    alias = object({
      name                   = string
      zone_id                = string
      evaluate_target_health = bool
    })
  }))
  description = "List of alias records to create"
  default     = []
} 