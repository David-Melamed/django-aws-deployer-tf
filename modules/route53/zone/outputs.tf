output "zone_id" {
  value = aws_route53_zone.ebs-lab.zone_id
}

output "zone_name" {
  value = var.zone_name
}

output "name_servers" {
  value = aws_route53_zone.ebs-lab.name_servers
}