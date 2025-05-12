output "rds_endpoint" {
  value       = aws_rds_cluster.db_cluster.endpoint
  description = "RDS instance endpoint"
}

output "rds_port" {
  value = aws_rds_cluster.db_cluster.port
}

output "rds_username" {
  value = aws_rds_cluster.db_cluster.master_username
}

output "rds_password" {
  value     = aws_rds_cluster.db_cluster.master_password
  sensitive = true

}
