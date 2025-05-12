output "zone_id" {
  description = "The ID of the hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "A list of name servers in associated delegation set"
  value       = aws_route53_zone.main.name_servers
}

output "zone_name" {
  description = "The name of the hosted zone"
  value       = aws_route53_zone.main.name
} 