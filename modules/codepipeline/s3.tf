resource "aws_s3_object" "dockerfile" {
  bucket = var.beanstalk_bucket_id
  key    = "Dockerfile"
  source = "Dockerfile"
  acl    = "public-read"

  depends_on = [
    aws_s3_bucket_acl.s3_bucket_acl, 
    aws_s3_bucket_public_access_block.bucket_acl_configuration
  ]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = var.beanstalk_bucket_id
  rule {
    object_ownership = "ObjectWriter"
  }

  depends_on = [
    aws_s3_bucket_public_access_block.bucket_acl_configuration
  ]
}

resource "aws_s3_bucket_public_access_block" "bucket_acl_configuration" {
  bucket = var.beanstalk_bucket_id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = var.beanstalk_bucket_id
  acl    = "public-read"
  
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership
  ]
}

data "aws_s3_bucket" "this" {
  bucket = var.beanstalk_bucket_id
}

resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = var.beanstalk_bucket_id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::${data.aws_s3_bucket.this.id}/Dockerfile"
      }
    ]
  })

  depends_on = [
    aws_s3_object.dockerfile
  ]
}
