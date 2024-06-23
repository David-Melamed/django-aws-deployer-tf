provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "django_app" {
  repository_name = "${var.app_name}_${var.env}"
  provider        = aws.us_east_1
  
  catalog_data {
    description = "ECR Public for Django Application"
  }
}