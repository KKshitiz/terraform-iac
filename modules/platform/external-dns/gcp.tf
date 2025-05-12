
# locals {
#   gcp_enabled = var.cloud_provider == "gcp"
# }

# # GCP-specific resources would go here
# resource "google_service_account" "external_dns" {
#   count        = local.gcp_enabled ? 1 : 0
#   account_id   = "${var.environment}-external-dns"
#   display_name = "External DNS Service Account"
#   project      = var.gcp_project
# }

# resource "google_project_iam_member" "dns_admin" {
#   count   = local.gcp_enabled ? 1 : 0
#   project = var.gcp_project
#   role    = "roles/dns.admin"
#   member  = "serviceAccount:${google_service_account.external_dns[0].email}"
# }

# locals {
#   gcp_service_account_annotations = local.gcp_enabled ? {
#     "iam.gke.io/gcp-service-account" = google_service_account.external_dns[0].email
#   } : {}

#   gcp_helm_values = {
#     provider = local.gcp_enabled ? "google" : null
#     google = local.gcp_enabled ? {
#       project = var.gcp_project
#     } : null
#     serviceAccount = local.gcp_enabled ? {
#       annotations = local.gcp_service_account_annotations
#     } : null
#   }
# }
