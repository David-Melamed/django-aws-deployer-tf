resource "aws_s3_bucket" "dockerrun_bucket" {
  bucket = var.bucket_name
  object_lock_enabled = false

  tags = {
          "elasticbeanstalk:environment-name" = format("%s-%s", var.ebs_app_name, var.env)
  }
}

resource "null_resource" "zip_application" {
  triggers = {
    version = var.application_version
  }

  provisioner "local-exec" {
    command = "zip -r ${var.ebs_app_name}-${var.application_version}.zip docker-compose.yml .ebextensions .platform"
  }
  depends_on = [null_resource.copy_ssh_key]
}

resource "aws_s3_object" "application_zip" {
  bucket = aws_s3_bucket.dockerrun_bucket.id
  key    = "beanstalk/${var.ebs_app_name}-${var.application_version}.zip"
  source = "${var.ebs_app_name}-${var.application_version}.zip"
}