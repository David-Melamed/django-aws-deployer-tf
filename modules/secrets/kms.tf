data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "kms_key" {
  description             = "KMS key for application encryption"
  deletion_window_in_days = 7  # Set the number of days before deletion
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.kms_alias}"
  target_key_id = aws_kms_key.kms_key.key_id
}

resource "local_file" "credentials" {
  content = jsonencode({
    db_name     = var.db_name     != "" ? var.db_name     : lookup(local.credentials, "db_name", "")
    db_username = var.db_username != "" ? var.db_username : lookup(local.credentials, "db_username", "")
    db_password = var.db_password != "" ? var.db_password : lookup(local.credentials, "db_password", "")
  })
  filename = "${path.module}/credentials.json"
  
  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = <<EOT
      if [ ! -f "${path.module}/credentials.json" ]; then
        json='${jsonencode(var.credentials)}'

        empty_values=false
        json_content="{"

        for key in $(echo $json | jq -r 'keys[]'); do
          value=$(echo $json | jq -r --arg key "$key" '.[$key]')
          if [ -z "$value" ]; then
            empty_values=true
            break
          fi
          json_content+="\"$key\": \"$value\","
        done

        if [ "$empty_values" = "false" ]; then
          json_content=$(echo "$json_content" | sed 's/,$//')
          json_content+="}"
          echo "$json_content" > "${path.module}/credentials.json"
        fi
      fi
    EOT
    when = create
  }
}

locals {
  credentials = try(jsondecode(file("${path.module}/credentials.json")), {})
  db_name     = var.db_name     != "" ? var.db_name     : lookup(local.credentials, "db_name", "")
  db_username = var.db_username != "" ? var.db_username : lookup(local.credentials, "db_username", "")
  db_password = var.db_password != "" ? var.db_password : lookup(local.credentials, "db_password", "")
}

data "external" "encrypt_db_name" {
  count   = local.db_name != "" ? 1 : 0
  program = ["${path.module}/encrypt.sh", aws_kms_key.kms_key.key_id, local.db_name, data.aws_region.current.name]
}

data "external" "encrypt_db_username" {
  count   = local.db_username != "" ? 1 : 0
  program = ["${path.module}/encrypt.sh", aws_kms_key.kms_key.key_id, local.db_username, data.aws_region.current.name]
}

data "external" "encrypt_db_password" {
  count   = local.db_password != "" ? 1 : 0
  program = ["${path.module}/encrypt.sh", aws_kms_key.kms_key.key_id, local.db_password, data.aws_region.current.name]
}

data "aws_kms_secrets" "db_dev" {
  count = (local.db_name != "" || local.db_username != "" || local.db_password != "") ? 1 : 0

  secret {
    name    = "db_name"
    payload = try(data.external.encrypt_db_name[0].result["encrypted_text"], "")
  }
  secret {
    name    = "db_username"
    payload = try(data.external.encrypt_db_username[0].result["encrypted_text"], "")
  }
  secret {
    name    = "db_password"
    payload = try(data.external.encrypt_db_password[0].result["encrypted_text"], "")
  }
}

resource "null_resource" "remove_credentials_file_when_destroy" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${path.module}/credentials.json"
  }
}