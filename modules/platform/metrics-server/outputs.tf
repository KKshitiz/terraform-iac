# outputs.tf
# Output values for metrics-server module

output "metrics_server_version" {
  description = "Version of metrics-server deployed"
  value       = helm_release.metrics_server.version
}
output "deployment_status" {
  description = "Status of metrics-server deployment"
  value       = helm_release.metrics_server.status
}
