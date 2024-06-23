data "aws_lb" "front_end" {
  arn = "${aws_elastic_beanstalk_environment.ebslab_env.load_balancers[0]}"
}

resource "aws_route53_record" "front_end" {
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "A"

  alias {
    name                   = data.aws_lb.front_end.dns_name
    zone_id                = data.aws_lb.front_end.zone_id
    evaluate_target_health = true
  }
}

output "lb_dns" {
  value = data.aws_lb.front_end.dns_name
}