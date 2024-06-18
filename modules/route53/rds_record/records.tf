resource "aws_route53_record" "rds-ns" {
  zone_id = var.zone_id
  name    = var.rds_record_name
  type    = "CNAME"
  ttl     = "15"
  records = ["${var.rds_address}"] 
}