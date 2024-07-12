resource "aws_s3_object" "dockerfile" {
  bucket = var.beanstalk_bucket_id
  key    = "scripts/Dockerfile"
  source = "${path.module}/scripts/Dockerfile"
  acl    = "public-read"
  depends_on = [ var.bucket_policy_arn ]
  etag = filesha256("${path.module}/scripts/Dockerfile")
}

resource "aws_s3_object" "override_settings" {
  bucket = var.beanstalk_bucket_id
  key    = "scripts/override_settings.py"
  source = "${path.module}/scripts/override_settings.py"
  acl    = "public-read"
  depends_on = [ var.bucket_policy_arn ]
  etag = filesha256("${path.module}/scripts/override_settings.py")
}

resource "aws_s3_object" "custom_settings" {
  bucket = var.beanstalk_bucket_id
  key    = "scripts/custom_settings.py"
  source = "${path.module}/scripts/custom_settings.py"
  acl    = "public-read"
  depends_on = [ var.bucket_policy_arn ]
  etag = filesha256("${path.module}/scripts/custom_settings.py")
}