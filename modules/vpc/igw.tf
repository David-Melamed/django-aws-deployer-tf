resource "aws_internet_gateway" "ebslab_gw" {
  vpc_id = aws_vpc.ebslab_vpc.id

  tags = {
    Name = var.tags
  }
}