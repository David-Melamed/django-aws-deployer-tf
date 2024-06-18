output "beanstalk_sg_id" {
  value = [aws_security_group.beanstalk_sg.id]
}

output "alb_sg_id" {
  value = [aws_security_group.alb_sg.id]
}