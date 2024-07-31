resource "aws_db_instance" "mysql_db" {
  allocated_storage = var.allocated_storage
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  username = var.username
  password = var.password
  db_name = replace(var.db_name, "-", "_")
  skip_final_snapshot = var.skip_final_snapshot
  vpc_security_group_ids = var.vpc_security_group_id
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  identifier = lower(var.identifier)
  tags = var.generic_tags
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.private_subnet_ids

  tags = var.generic_tags
}