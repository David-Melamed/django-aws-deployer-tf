variable "bucket_name" {}
variable "beanstalk_app_name" {}
variable "env" {}
variable "generic_tags" {
  description = "Generic tags from the root module"
  type        = map(string)
}