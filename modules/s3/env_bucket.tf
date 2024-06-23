resource "aws_s3_bucket" "beanstalk_bucket" {
  bucket = var.bucket_name
  object_lock_enabled = false

  tags = {
          "elasticbeanstalk:environment-name" = format("%s-%s", var.beanstalk_app_name, var.env)
  }
}