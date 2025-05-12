# outputs.tf
# Output values for karpenter module

output "karpenter_controller_role" {
  value = aws_iam_role.karpenter_controller.arn
}

output "karpenter_node_instance_profile" {
  value = aws_iam_instance_profile.karpenter_node.arn
}
