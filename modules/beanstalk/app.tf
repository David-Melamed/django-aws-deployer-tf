resource "aws_elastic_beanstalk_application" "ebslab_app" {
  name        = var.ebs_app_name
  description = var.ebs_app_description

    tags = {
          "environment-name" = format("%s-%s", var.ebs_app_name, var.env)
    }
}


resource "aws_elastic_beanstalk_application_version" "app_version" {
  name        = format("%s-%s-%s", var.ebs_app_name, var.env, var.application_version)
  application = aws_elastic_beanstalk_application.ebslab_app.name
  bucket      = aws_s3_bucket.dockerrun_bucket.id
  key         = aws_s3_object.application_zip.key
}