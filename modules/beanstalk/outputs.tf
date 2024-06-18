output "ebs_environment_url" {
  value = aws_elastic_beanstalk_environment.ebslab_env.endpoint_url
}

output "ebs_app_name" {
  value = aws_elastic_beanstalk_application.ebslab_app.name
}

output "instance_private_ips" {
  value = aws_elastic_beanstalk_environment.ebslab_env.instances
  sensitive = true
}

output "env" {
  value = aws_elastic_beanstalk_environment.ebslab_env.name
}

output "beanstalk_cname_prefix" {
  value = join("-", [var.ebs_app_name, var.env])
}

output "ebs_app_description" {
  value = var.ebs_app_description
}

output "service_role_name" {
  value = var.service_role_name
}

output "instance_type" {
  value = var.instance_type
}

output "application_version" {
  value = var.application_version
}

output "bucket_name" {
  value = var.bucket_name
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.ebslab_env.name
}