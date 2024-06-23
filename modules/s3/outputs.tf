output "beanstalk_bucket_id" {
    value = aws_s3_bucket.beanstalk_bucket.id
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.beanstalk_bucket.bucket_regional_domain_name
}
