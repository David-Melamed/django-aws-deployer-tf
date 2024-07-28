variable allocated_storage {}
variable engine {}
variable instance_class {}
variable username {}
variable password {}
variable skip_final_snapshot {}
variable subnet_name {}
variable engine_version {}
variable db_name {}
variable vpc_id {}
variable instance_private_ips {
  type = list(any)
}
variable vpc_security_group_id {
  type = list(string)
}
variable subnet_ids {
  type = list(any)
}

variable private_subnet_ids {
  type = list(any)
}

variable public_subnet_ids {
  type = list(any)
}

variable identifier {}
variable "generic_tags" {
  description = "Generic tags from the root module"
  type        = map(string)
}