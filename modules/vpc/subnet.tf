data "aws_availability_zones" "available" {}

resource "aws_subnet" "ebslab_subnets" {
  count                   = length(var.subnets)
  vpc_id                  = aws_vpc.ebslab_vpc.id
  cidr_block              = var.subnets[count.index].cidr_block
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = var.subnets[count.index].public
  tags                    = merge(var.generic_tags, var.subnets[count.index].tags)
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = 2
}