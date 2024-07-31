locals {
  bucket_name = lower(var.bucket_name)
  specific_tags = {
    "elasticbeanstalk:environment-name" = format("%s-%s", var.beanstalk_app_name, var.env)
  }
  combined_tags = merge(var.generic_tags, local.specific_tags)
}