variable "tags" {
  description = "Tags applied to all resources"
  type        = string
  default     = "ebs-lab"
}

variable "instance_tenancy" {
  description = "EC2 instance tenancy"
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_sn_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "public_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "rt_route_cidr_block" {
  description = "CIDR block for the routing table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_dns_hostnames" {
  description = "Flag to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Flag to map public IP on launch in the subnets"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Storage allocated for RDS instance"
  type        = number
  default     = 10
}

variable "engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Version of the MySQL database engine"
  type        = string
  default     = "5.7"
}

variable "skip_final_snapshot" {
  description = "Flag to skip the final snapshot when deleting RDS instance"
  type        = bool
  default     = true
}

variable "ebs_app_description" {
  description = "Description of the Elastic Beanstalk application"
  type        = string
  default     = "Python Web App Application using Django Framework"
}

variable "solution_stack_name" {
  description = "Solution stack for the Elastic Beanstalk environment"
  type        = string
  default     = "64bit Amazon Linux 2023 v4.3.2 running Docker"
}

variable "service_role_name" {
  description = "Beanstalk IAM role assigned to the EC2 instances"
  type        = string
  default     = "aws-elasticbeanstalk-ec2-role"
}

variable "instance_type" {
  description = "Instance type for the Elastic Beanstalk environment"
  type        = string
  default     = "t3.small"
}

variable "ssh_public_key_local_path" {
  description = "Local path to the SSH public key"
  type        = string
  default     = "$HOME/.ssh/id_rsa.pub"
}


variable "db_username" {
  description = "Database username"
  type        = string
  default     = "dbusername1"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "dbpassword1"
}

variable "app_name" {
  description = "Applcation name"
  type        = string
  default     = "myapptest"
}

variable "django_project_url" {
  description = "Django project URL"
  type        = string
  default = "https://github.com/David-Melamed/django-swap-app.git"
}