resource "aws_elastic_beanstalk_application" "ebslab_app" {
  count = var.image_build_status ? 1 : 0
  name        = var.ebs_app_name
  description = var.ebs_app_description

    tags = {
          "environment-name" = format("%s-%s", var.ebs_app_name, var.env)
    }
}


resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = format("%s-%s-%s", var.ebs_app_name, var.env, var.application_version)
  application = var.image_build_status ? aws_elastic_beanstalk_application.ebslab_app[0].name : ""
  bucket      = var.beanstalk_bucket_id
  key         = aws_s3_object.application_zip.key
}