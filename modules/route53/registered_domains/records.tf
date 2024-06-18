resource "aws_route53domains_registered_domain" "web_name_servers" {
  domain_name = var.zone_name

  dynamic "name_server" {
    for_each = var.zone_web_name_servers
    content {
      name = name_server.value
    }
  }

  tags = {
    Environment = "dev"
  }
}
