# Combine provider-specific annotations and values
locals {
  service_account_annotations = merge(
    local.aws_service_account_annotations,
    # local.azure_service_account_annotations,
    # local.gcp_service_account_annotations
  )

  provider_specific_values = merge(
    local.aws_helm_values,
    # local.azure_helm_values,
    # local.gcp_helm_values
  )

  # Helper function to remove null values from a map
  compact_map = { for k, v in local.provider_specific_values : k => v if v != null }

  # Merge common and provider-specific values
  helm_values = merge(local.common_helm_values, local.compact_map)
}


# Common Helm values
locals {
  common_helm_values = {
    domainFilters = var.domain_names
    txtOwnerId    = var.environment
    policy        = "sync"
    registry      = "txt"
    interval      = "1m"
    sources       = ["ingress", "service"]
    txtPrefix     = "k8s"
    rbac = {
      create = true
    }
    metrics = {
      enabled = true
      serviceMonitor = {
        enabled = true
      }
    }
    resources = {
      limits = {
        cpu    = "100m"
        memory = "300Mi"
      }
      requests = {
        cpu    = "50m"
        memory = "150Mi"
      }
    }
    serviceAccount = {
      create      = true
      name        = "external-dns"
      annotations = local.service_account_annotations
    }
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "1.13.0"

  values = [yamlencode(local.helm_values)]
}
