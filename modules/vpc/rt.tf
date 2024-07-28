resource "aws_default_route_table" "internal_ebslab_default" {
  default_route_table_id = aws_vpc.ebslab_vpc.default_route_table_id

  route {
    cidr_block = var.rt_route_cidr_block
    gateway_id = aws_internet_gateway.ebslab_gw.id
  }

  tags = var.generic_tags
}

resource "aws_route_table_association" "default" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.ebslab_subnets[count.index].id
  route_table_id = aws_default_route_table.internal_ebslab_default.id
}
