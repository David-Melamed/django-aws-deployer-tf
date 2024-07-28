locals {
  db_host            = "rds-${var.env}.${var.zone_name}"
  repo_owner         = regex("https://github.com/([^/]+)/", var.django_project_url)[0]
  repo_name          = regex("https://github.com/[^/]+/([^/]+).git", var.django_project_url)[0]
  date_creation      = formatdate("YYYY-MM-DD", timestamp())
  creator_name       = data.external.current_user.result.creator_name
  
  generic_tags = {
    ApplicationName = var.app_name,
    Environment     = var.env,
    DateCreation    = formatdate("YYYY-MM-DDTHH:MM:SSZ", timestamp())
    CreatorName     = local.creator_name
  }
}

data "external" "current_user" {
  program = ["sh", "-c", "echo '{\"creator_name\": \"'$(whoami)'\"}'"]
}