resource "helm_release" "nginx" {
  name      = "nginx"
  namespace = var.namespace

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.chart_version

  # values = [
  #   file("${path.module}/values.yaml")
  # ]
}
