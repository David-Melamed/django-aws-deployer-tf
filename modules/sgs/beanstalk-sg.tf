# Create a security group
resource "aws_security_group" "beanstalk_sg" {
  vpc_id      = var.vpc_id
  name        = "beanstalk-sg"
  description = "Security group for Elastic Beanstalk"
}

resource "aws_security_group_rule" "beanstalk_sg_rule_80" {
  security_group_id = aws_security_group.beanstalk_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.beanstalk_sg.id
}

resource "aws_security_group_rule" "beanstalk_sg_rule_ssh" {
  security_group_id = aws_security_group.beanstalk_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Allow SSH from any IP address
}

resource "aws_security_group_rule" "beanstalk_sg_rule_ssl" {
  security_group_id = aws_security_group.beanstalk_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Allow secure connection from any IP address
}

resource "aws_security_group_rule" "internal_mysql_communication" {
  security_group_id = aws_security_group.beanstalk_sg.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = aws_security_group.beanstalk_sg.id
}