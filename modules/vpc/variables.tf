variable "vpc_cidr" {}
variable "instance_tenancy" {}
variable "tags" {}
variable "map_public_ip_on_launch" {}
variable "rt_route_cidr_block" {}
variable sg_name {}
variable enable_dns_hostnames {
  type = bool
}

variable "generic_tags" {
  description = "Generic tags from the root module"
  type        = map(string)
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    cidr_block              = string
    public                  = bool
    tags                    = map(string)
  }))
  default = [
    {
      cidr_block = "10.0.1.0/24"
      public     = true
      tags       = { Name = "Public-Subnet" }
    },
    {
      cidr_block = "10.0.2.0/24"
      public     = true
      tags       = { Name = "Public-Subnet" }
    },
    {
      cidr_block = "10.0.3.0/24"
      public     = false
      tags       = { Name = "Private-Subnet" }
    },
    {
      cidr_block = "10.0.4.0/24"
      public     = false
      tags       = { Name = "Private-Subnet" }
    }
  ]
}
