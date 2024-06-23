resource "aws_s3_object" "dockerfile" {
  bucket = var.beanstalk_bucket_id
  key    = "Dockerfile"
  source = "Dockerfile"
  acl    = "public-read"
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = var.beanstalk_bucket_id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = var.beanstalk_bucket_id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = var.beanstalk_bucket_id
  acl    = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
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
        Resource = "arn:aws:s3:::${var.beanstalk_bucket_id}/Dockerfile"
      }
    ]
  })
}

