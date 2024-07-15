output "beanstalk_bucket_id" {
    value = aws_s3_bucket.beanstalk_bucket.id
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.beanstalk_bucket.bucket_regional_domain_name
}

output "bucket_policy_arn" {
    value = aws_s3_bucket.beanstalk_bucket.arn
}

output "s3_bucket_acl_ready" {
  value       = "ACL is ready and public-read is set"
  description = "Indicates when the S3 bucket ACL is configured to public-read"
  depends_on  = [aws_s3_bucket_acl.s3_bucket_acl]
}