resource "aws_iam_role" "ebs_csi_role" {
  name = "${var.environment}-${var.project_name}-AmazonEKS_EBS_CSI_Driver_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

# Attach AWS-managed EBS CSI driver policy
resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_role.name
}

resource "kubernetes_service_account" "ebs_csi" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_role.arn
    }
  }
}

# Create a token for the service account (for K8s v1.24+)
resource "kubernetes_secret" "ebs_csi_token" {
  metadata {
    name      = "ebs-csi-token"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.ebs_csi.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    yamlencode({
      controller = {
        serviceAccount = {
          create = false
          name   = kubernetes_service_account.ebs_csi.metadata[0].name
        }
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.ebs_csi,
    kubernetes_secret.ebs_csi_token
  ]
}

resource "kubernetes_storage_class" "ebs_sc" {
  metadata {
    name = "ebs-sc"
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type   = "gp3" # Change to gp2, io1, etc., based on your requirements
    fsType = "ext4"
  }

  reclaim_policy         = "Retain"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
}
