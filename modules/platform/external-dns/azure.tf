
# locals {
#   azure_enabled = var.cloud_provider == "azure"
# }

# # Azure-specific resources would go here
# resource "azurerm_user_assigned_identity" "external_dns" {
#   count               = local.azure_enabled ? 1 : 0
#   name                = "${var.environment}-external-dns-identity"
#   resource_group_name = var.azure_resource_group_name
#   location            = "eastus" # You might want to make this configurable
# }

# resource "azurerm_role_assignment" "dns_contributor" {
#   count                = local.azure_enabled ? 1 : 0
#   scope                = "/subscriptions/${var.azure_subscription_id}"
#   role_definition_name = "DNS Zone Contributor"
#   principal_id         = azurerm_user_assigned_identity.external_dns[0].principal_id
# }

# locals {
#   azure_service_account_annotations = local.azure_enabled ? {
#     "azure.workload.identity/client-id" = azurerm_user_assigned_identity.external_dns[0].client_id
#   } : {}

#   azure_helm_values = {
#     provider = local.azure_enabled ? "azure" : null
#     azure = local.azure_enabled ? {
#       resourceGroup               = var.azure_resource_group_name
#       subscriptionId              = var.azure_subscription_id
#       tenantId                    = var.azure_tenant_id
#       useManagedIdentityExtension = true
#     } : null
#     serviceAccount = local.azure_enabled ? {
#       annotations = local.azure_service_account_annotations
#     } : null
#   }
# }
