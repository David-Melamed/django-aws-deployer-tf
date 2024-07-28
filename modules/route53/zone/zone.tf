resource "aws_route53_zone" "ebs-lab" {
  name = var.zone_name
    
  tags = var.generic_tags
}


resource "aws_route53_record" "ns_record" {
  allow_overwrite = true
  name            = var.zone_name
  ttl             = 60
  type            = "NS"
  zone_id         = aws_route53_zone.ebs-lab.zone_id

  records = [
    aws_route53_zone.ebs-lab.name_servers[0],
    aws_route53_zone.ebs-lab.name_servers[1],
    aws_route53_zone.ebs-lab.name_servers[2],
    aws_route53_zone.ebs-lab.name_servers[3]
  ]
}