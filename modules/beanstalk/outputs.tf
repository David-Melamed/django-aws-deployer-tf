
output "ebs_environment_url" {
  value = var.image_build_status && length(aws_elastic_beanstalk_environment.ebslab_env) > 0 ? aws_elastic_beanstalk_environment.ebslab_env[0].endpoint_url : ""
}

output "ebs_app_name" {
  value = var.image_build_status && length(aws_elastic_beanstalk_application.ebslab_app) > 0 ? aws_elastic_beanstalk_application.ebslab_app[0].name : ""
}

output "instance_private_ips" {
  value = var.image_build_status && length(aws_elastic_beanstalk_environment.ebslab_env) > 0 ? aws_elastic_beanstalk_environment.ebslab_env[0].instances : []
  sensitive = true
}

output "env" {
  value = var.image_build_status && length(aws_elastic_beanstalk_environment.ebslab_env) > 0 ? aws_elastic_beanstalk_environment.ebslab_env[0].name : ""
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
  value = var.image_build_status && length(aws_elastic_beanstalk_environment.ebslab_env) > 0 ? aws_elastic_beanstalk_environment.ebslab_env[0].name : ""
}

output "django_project_name" {
  value = local.django_project_name
}

output "ec2_public_ips" {
  value = data.aws_instances.beanstalk_instances[*].public_ips
}