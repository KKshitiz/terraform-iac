# Create ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
    labels = {
      Environment = var.environment
      managedBy   = "terraform"
    }
  }
}

# Deploy ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = var.chart_version

  values = [file("${path.module}/values.yaml")]

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.admin_password
  }

  set_sensitive {
    name  = "notifications.secret.items.slack-token"
    value = var.slack_token
  }

  depends_on = [
    kubernetes_namespace.argocd,
    local_file.argocd_values
  ]
}
