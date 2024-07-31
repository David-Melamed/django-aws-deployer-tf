# Create a security group
resource "aws_security_group" "alb_sg" {
  vpc_id      = var.vpc_id
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  tags = var.generic_tags
}

resource "aws_security_group_rule" "alb_sg_rule_80" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}