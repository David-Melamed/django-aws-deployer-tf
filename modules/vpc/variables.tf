variable "vpc_cidr" {}
variable "public_sn_count" {}
variable "instance_tenancy" {}
variable "tags" {}
variable "map_public_ip_on_launch" {}
variable "rt_route_cidr_block" {}
variable sg_name {}
variable enable_dns_hostnames {
  type = bool
}
variable "public_cidrs" {
  type = list(any)
}

