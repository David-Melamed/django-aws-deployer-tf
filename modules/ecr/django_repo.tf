provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Define the repository name as a separate resource using locals
locals {
  repository_name = lower(replace("${var.app_name}_${var.env}", "-", "_"))
}

# Create the ECR repository
resource "aws_ecrpublic_repository" "django_app" {
  repository_name = local.repository_name
  provider        = aws.us_east_1

  catalog_data {
    description = "ECR Public for Django Application"
  }

  # Ensure the repository depends on the null resource that deletes images
  lifecycle {
    create_before_destroy = true
  }
}