locals {
  db_host            = "rds-${var.env}.${var.zone_name}"
  repo_owner         = regex("https://github.com/([^/]+)/", var.django_project_url)[0]
  repo_name          = regex("https://github.com/[^/]+/([^/]+).git", var.django_project_url)[0]
  generic_tags = {
    ApplicationName = var.app_name,
    Environment     = var.env
  }
}