data "aws_instances" "beanstalk_instances" {
  filter {
    name   = "tag:environment-name"
    values = [aws_elastic_beanstalk_environment.ebslab_env.name]
  }
#   filter {
#     name   = "instance.group-id"
#     values = var.beanstalk_sg_id
#   }
}

output "ec2_public_ips" {
  value = data.aws_instances.beanstalk_instances[*].public_ips
}

# data "aws_autoscaling_groups" "beanstalk_asgs" {
#   filter {
#     name   = "tag:elasticbeanstalk:environment-name"
#     values = [aws_elastic_beanstalk_environment.ebslab_env.name]
#   }
# }

# data "aws_autoscaling_group" "beanstalk_asg" {
#   count = length(data.aws_autoscaling_groups.beanstalk_asgs.names)
#   name  = data.aws_autoscaling_groups.beanstalk_asgs.names[count.index]
# }