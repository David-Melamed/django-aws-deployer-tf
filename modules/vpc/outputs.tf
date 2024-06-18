output "public_subnet_ids" {
  value = [for s in aws_subnet.ebslab_subnets : s.id if s.map_public_ip_on_launch]
  description = "List of IDs of public subnets"
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.ebslab_subnets : s.id if !s.map_public_ip_on_launch]
  description = "List of IDs of private subnets"
}

output "vpc_id" {
  value = aws_vpc.ebslab_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.ebslab_subnets[*].id
}

output "subnet_availability_zones" {
  value = aws_subnet.ebslab_subnets[*].availability_zone
}

output "sg_name" {
  value = aws_subnet.ebslab_subnets[0].tags["Name"]
}