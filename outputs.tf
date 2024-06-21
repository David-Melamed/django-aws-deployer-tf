output "ec2_public_ips" {
  value = module.beanstalk.ec2_public_ips
}

output "beanstalk_env_name" {
  value = module.beanstalk.environment_name
}

output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

output "web_url" {
  value = "https://${module.route53_zone.zone_name}"
}