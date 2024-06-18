output "db_name" {
  value = data.aws_kms_secrets.db_dev[0].plaintext["db_name"]
}

output "db_username" {
  value = data.aws_kms_secrets.db_dev[0].plaintext["db_username"]
}

output "db_password" {
  value = data.aws_kms_secrets.db_dev[0].plaintext["db_password"]
}

output "kms_key_arn"{
  value = aws_kms_key.kms_key.arn
}
