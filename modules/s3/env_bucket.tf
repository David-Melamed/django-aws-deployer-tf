resource "random_id" "bucket_suffix" {
  byte_length = 4
}

locals {
  bucket_name = lower(var.bucket_name)
}

resource "aws_s3_bucket" "beanstalk_bucket" {
  bucket = "${local.bucket_name}-${random_id.bucket_suffix.hex}"
  object_lock_enabled = false

  tags = {
          "elasticbeanstalk:environment-name" = format("%s-%s", var.beanstalk_app_name, var.env)
  }
}