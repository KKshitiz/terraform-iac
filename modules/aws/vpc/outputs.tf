# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

# output "alb_security_group_id" {
#   value = aws_security_group.alb.id
# }

output "eks_nodes_security_group_id" {
  value = aws_security_group.eks_nodes.id
}
