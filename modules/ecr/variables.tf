variable "image_tag" {}
variable "django_project_url" {}
variable "app_name" {}
variable "env" {}
variable "image_platform" {}
variable "ecr_region" {}
variable "generic_tags" {
  description = "Generic tags from the root module"
  type        = map(string)
}