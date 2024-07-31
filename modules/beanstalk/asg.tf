data "aws_instances" "beanstalk_instances" {
  count = var.image_build_status ? 1 : 0
  filter {
    name   = "tag:environment-name"
    values = var.image_build_status ? [aws_elastic_beanstalk_environment.ebslab_env[0].name] : [""]
  }
}

