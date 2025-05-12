variable "environment" {
  type        = string
  description = "Environment name"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy ArgoCD to"
  default     = "argocd"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "5.46.7"
}

variable "admin_password" {
  type = string
  # Generate using bcrypt
  # htpasswd -nbBC 10 "" $ARGO_PWD | tr -d ':\n' | sed 's/$2y/$2a/'
  description = "ArgoCD admin password"
  sensitive   = true
}

variable "slack_notifications_channel" {
  type        = string
  description = "Slack channel for notifications"
}

variable "slack_token" {
  type        = string
  description = "Slack token for notifications"
  sensitive   = true
}
