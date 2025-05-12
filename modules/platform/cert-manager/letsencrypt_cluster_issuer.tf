# Note: Apply this resource after the cert-manager is installed
# ClusterIssuer resource for Let's Encrypt production
resource "kubernetes_manifest" "letsencrypt_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }
    spec = {
      acme = {
        email  = var.acme_email
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "unirsal-issuer-account-key"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }

  # Ensure cert-manager is installed before creating the ClusterIssuer
  depends_on = [helm_release.cert_manager]
}


# ClusterIssuer resource for Let's Encrypt production
resource "kubernetes_manifest" "letsencrypt_production" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-production"
    }
    spec = {
      acme = {
        email  = var.acme_email
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "unirsal-issuer-account-key"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }

  # Ensure cert-manager is installed before creating the ClusterIssuer
  depends_on = [helm_release.cert_manager]
}
