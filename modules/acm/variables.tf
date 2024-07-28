variable "domain_name" {}
variable "zone_id" {}
variable "generic_tags" {
  description = "Generic tags from the root module"
  type        = map(string)
}