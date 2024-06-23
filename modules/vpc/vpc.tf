resource "aws_vpc" "ebslab_vpc" {
  cidr_block       = var.vpc_cidr 
  enable_dns_hostnames = var.enable_dns_hostnames

  instance_tenancy = var.instance_tenancy
  tags = {
    Name = var.tags
  }
}