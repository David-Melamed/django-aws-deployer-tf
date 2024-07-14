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

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.beanstalk_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }

  depends_on = [
    aws_s3_bucket_public_access_block.bucket_acl_configuration
  ]
}

resource "aws_s3_bucket_public_access_block" "bucket_acl_configuration" {
  bucket = aws_s3_bucket.beanstalk_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.beanstalk_bucket.id
  acl    = "public-read"
  
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership
  ]
}

resource "aws_s3_bucket_policy" "public_access_policy" {
  bucket = aws_s3_bucket.beanstalk_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.beanstalk_bucket.id}"
        ]
      },
      {
        Effect = "Allow",
        Principal = "*",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.beanstalk_bucket.id}/*"
        ]
      }
    ]
  })
}
