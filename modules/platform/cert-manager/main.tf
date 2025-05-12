resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = var.namespace

    labels = {
      environment = var.environment
      managedBy   = "terraform"
    }
  }
}

locals {
  values = {
    installCRDs = true
    podDnsConfig = {
      nameservers = ["1.1.1.1", "8.8.8.8"]
      policy      = "None"
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = kubernetes_namespace.cert-manager.metadata[0].name
  version    = var.chart_version
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = [
    yamlencode(local.values)
  ]
}
