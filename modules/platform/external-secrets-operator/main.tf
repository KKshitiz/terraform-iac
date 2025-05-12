data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Create IAM policy for External Secrets Operator to access Secrets Manager
resource "aws_iam_policy" "external_secrets_policy" {
  name        = "${var.environment}-${var.project_name}-external-secrets-policy"
  description = "IAM policy for External Secrets Operator to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = [
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:ListSecrets"
        ]
        Resource = ["*"]
      }
    ]
  })
}

resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"

    labels = {
      Environment = var.environment
    }
  }
}

# Create IAM role for the Service Account
module "iam_assumable_role_external_secrets" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = "${var.environment}-${var.project_name}-external-secrets-irsa"
  provider_url                  = var.oidc_provider_url
  role_policy_arns              = [aws_iam_policy.external_secrets_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-secrets:external-secrets-sa"]
}

# Install External Secrets Operator using Helm
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = kubernetes_namespace.external_secrets.metadata[0].name
  create_namespace = false
  version          = "0.9.9"

  values = [
    yamlencode({
      installCRDs = true
      serviceAccount = {
        create = true
        name   = "external-secrets-sa"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.iam_assumable_role_external_secrets.iam_role_arn
        }
      }
    })
  ]
}

# TODO: Uncomment this when we have a secret store
# Create SecretStore and ExternalSecret using Kubernetes provider
resource "kubernetes_manifest" "cluster_secret_store" {

  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "aws-secretsmanager"
    }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = data.aws_region.current.name
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = "external-secrets-sa"
                namespace = kubernetes_namespace.external_secrets.metadata[0].name
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.external_secrets]
}
