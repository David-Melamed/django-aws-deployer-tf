variable "role_name" {}
variable "kms_key_arn" {}
variable "generic_tags" {
  description = "Generic tags from the root module"
  type        = map(string)
}