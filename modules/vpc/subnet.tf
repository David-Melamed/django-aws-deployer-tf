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

data "aws_availability_zones" "available" {}

resource "aws_subnet" "ebslab_subnets" {
  count                   = length(var.subnets)
  vpc_id                  = aws_vpc.ebslab_vpc.id
  cidr_block              = var.subnets[count.index].cidr_block
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = var.subnets[count.index].public
  tags                    = var.subnets[count.index].tags
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = 2
}