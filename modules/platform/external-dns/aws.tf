locals {
  aws_enabled = var.cloud_provider == "aws"
}

data "aws_region" "current" {
  count = local.aws_enabled ? 1 : 0
}

# Get existing hosted zones
data "aws_route53_zone" "zones" {
  for_each = local.aws_enabled ? toset(var.domain_names) : []
  name     = each.value
}

# IAM Policy for ExternalDNS
resource "aws_iam_policy" "external_dns" {
  count       = local.aws_enabled ? 1 : 0
  name        = "${var.environment}-external-dns-policy"
  description = "Policy for ExternalDNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [for zone in data.aws_route53_zone.zones : "arn:aws:route53:::hostedzone/${zone.zone_id}"]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for ExternalDNS
resource "aws_iam_role" "external_dns" {
  count = local.aws_enabled ? 1 : 0
  name  = "${var.environment}-external-dns-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = var.aws_oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${var.aws_oidc_provider_url}:sub" : "system:serviceaccount:kube-system:external-dns"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  count      = local.aws_enabled ? 1 : 0
  policy_arn = aws_iam_policy.external_dns[0].arn
  role       = aws_iam_role.external_dns[0].name
}

# Return AWS-specific service account annotations
locals {
  aws_service_account_annotations = local.aws_enabled ? {
    "eks.amazonaws.com/role-arn" = aws_iam_role.external_dns[0].arn
  } : {}

  aws_helm_values = {
    provider = local.aws_enabled ? "aws" : null
    aws = local.aws_enabled ? {
      region   = data.aws_region.current[0].name
      zoneType = "public"
    } : null
    serviceAccount = local.aws_enabled ? {
      annotations = local.aws_service_account_annotations
    } : null
  }
}
