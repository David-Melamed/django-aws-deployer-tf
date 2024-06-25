locals {
  lb_dns_name = var.image_build_status && length(data.aws_lb.front_end) > 0 ? data.aws_lb.front_end[0].dns_name : ""
  lb_zone_id  = var.image_build_status && length(data.aws_lb.front_end) > 0 ? data.aws_lb.front_end[0].zone_id : ""
}

data "aws_lb" "front_end" {
  count = var.image_build_status ? 1 : 0
  arn   = var.image_build_status ? aws_elastic_beanstalk_environment.ebslab_env[0].load_balancers[0] : null
}

resource "aws_route53_record" "front_end" {
  count = var.image_build_status ? 1 : 0
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "A"

  alias {
    name                   = local.lb_dns_name
    zone_id                = local.lb_zone_id
    evaluate_target_health = true
  }
}