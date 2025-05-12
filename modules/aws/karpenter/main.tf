# main.tf
# Terraform resources for karpenter module
data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_iam_policy_document" "karpenter_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${data.aws_eks_cluster.this.identity[0].oidc[0].issuer}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  name               = "${var.environment}-${var.project_name}-karpenter-controller"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role.json
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAutoscalerPolicy"
}

resource "aws_iam_role" "karpenter_node" {
  name = "${var.environment}-${var.project_name}-karpenter-node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_node_policy" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_instance_profile" "karpenter_node" {
  name = "${var.environment}-${var.project_name}-karpenter-node"
  role = aws_iam_role.karpenter_node.name

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"
  repository       = "https://charts.karpenter.sh"
  chart            = "karpenter"
  version          = var.chart_version
  create_namespace = true

  values = [templatefile("${path.module}/karpenter-values.yaml", {
    cluster_name             = var.cluster_name
    cluster_endpoint         = data.aws_eks_cluster.this.endpoint
    karpenter_iam_role_arn   = aws_iam_role.karpenter_controller.arn
    default_instance_profile = aws_iam_instance_profile.karpenter_node.name
    account_id               = data.aws_caller_identity.current.account_id
  })]
}
