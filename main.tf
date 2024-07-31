# S3 Module
module "s3" {
  source             = "./modules/s3"
  bucket_name        = "${var.app_name}-${var.env}"
  env                = var.env
  beanstalk_app_name = var.app_name
  generic_tags       = local.generic_tags
}

# VPC Module
module "vpc" {
  source                  = "./modules/vpc"
  tags                    = "test1"
  instance_tenancy        = var.instance_tenancy
  vpc_cidr                = var.vpc_cidr
  public_sn_count         = var.public_sn_count
  public_cidrs            = var.public_cidrs
  rt_route_cidr_block     = var.rt_route_cidr_block
  sg_name                 = "${var.app_name}-${var.env}-sg"
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch
  generic_tags       = local.generic_tags
}

# Security Groups Module
module "sgs" {
  source = "./modules/sgs"
  vpc_id = module.vpc.vpc_id
  generic_tags       = local.generic_tags
}

# Secrets Module
module "secrets" {
  source       = "./modules/secrets"
  kms_alias    = "${var.app_name}-${var.env}-kms-alias"
  db_name      = "${var.app_name}-${var.env}"
  db_username  = var.db_username
  db_password  = var.db_password
  generic_tags = local.generic_tags
}

# IAM Module
module "iam" {
  source       = "./modules/iam"
  kms_key_arn  = module.secrets.kms_key_arn
  role_name    = "${var.app_name}-${var.env}-role"
  generic_tags = local.generic_tags
}

# RDS Module
module "rds" {
  source                = "./modules/rds"
  allocated_storage     = var.allocated_storage
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.rds_instance_class
  username              = module.secrets.db_username
  password              = module.secrets.db_password
  db_name               = module.secrets.db_name
  identifier            = "${var.app_name}-${var.env}"
  skip_final_snapshot   = var.skip_final_snapshot
  subnet_name           = module.vpc.sg_name
  subnet_ids            = module.vpc.subnet_ids
  vpc_security_group_id = module.sgs.beanstalk_sg_id
  vpc_id                = module.vpc.vpc_id
  instance_private_ips  = module.beanstalk.instance_private_ips
  private_subnet_ids    = module.vpc.private_subnet_ids
  public_subnet_ids     = module.vpc.public_subnet_ids
  generic_tags          = local.generic_tags
}

# Route 53 Zone Module
module "route53_zone" {
  source       = "./modules/route53/zone"
  zone_name    = var.zone_name
  vpc_id       = module.vpc.vpc_id
  generic_tags = local.generic_tags
}

# Route 53 RDS Record Module
module "route53_rds_record" {
  source          = "./modules/route53/rds_record"
  rds_record_name = "rds-${var.env}"
  zone_name       = module.route53_zone.zone_name
  rds_address     = module.rds.db_endpoint
  zone_id         = module.route53_zone.zone_id
}

# Route 53 Registered Domains Module
module "route53_registered_domains" {
  source                = "./modules/route53/registered_domains"
  zone_name             = module.route53_zone.zone_name
  zone_id               = module.route53_zone.zone_id
  zone_web_name_servers = module.route53_zone.name_servers
}

# ACM Module (HTTPS Encryption)
module "acm" {
  source       = "./modules/acm"
  domain_name  = module.route53_zone.zone_name
  zone_id      = module.route53_zone.zone_id
  generic_tags = local.generic_tags
}

# ECR Module (Create Public ECR)
module "ecr" {
  source             = "./modules/ecr"
  app_name           = var.app_name
  image_tag          = var.app_version
  django_project_url = var.django_project_url
  env                = var.env
  image_platform     = var.image_platform
  ecr_region         = var.ecr_region
  generic_tags       = local.generic_tags
}

# CodeBuild Module (Build and Push Image)
module "codebuild" { 
  source                      = "./modules/codebuild"
  app_name                    = var.app_name
  image_tag                   = var.app_version
  django_project_url          = var.django_project_url
  env                         = var.env
  image_platform              = var.image_platform
  ecr_region                  = var.ecr_region
  pipeline_name               = "${var.app_name}-${var.env}"
  pipeline_role_arn           = module.iam.pipeline_role_arn
  s3_bucket_name              = "${var.app_name}-${var.env}"
  stage_version               = var.app_version
  codebuild_role_arn          = module.iam.codebuild_role_arn
  ecr_repository_name         = module.ecr.ecr_repository_name
  app_version                 = var.app_version
  repo_owner                  = local.repo_owner
  repo_name                   = local.repo_name
  beanstalk_bucket_id         = module.s3.beanstalk_bucket_id
  ecr_repository_url          = module.ecr.ecr_repository_url
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  docker_username             = var.docker_username
  docker_password             = var.docker_password
  bucket_policy_arn           = module.s3.bucket_policy_arn
  s3_bucket_acl_ready         = module.s3.s3_bucket_acl_ready
  generic_tags                = local.generic_tags
}

# Beanstalk Module
module "beanstalk" {
  source                    = "./modules/beanstalk"
  ebs_app_name              = var.app_name
  ebs_app_description       = var.ebs_app_description
  solution_stack_name       = var.solution_stack_name
  env                       = var.env
  service_role_name         = var.service_role_name
  instance_type             = var.instance_type
  bucket_name               = "${var.app_name}-${var.env}-${var.app_version}-bucket"
  application_version       = var.app_version
  ssh_public_key_local_path = var.ssh_public_key_local_path
  service_role_arn          = module.iam.role_arn
  vpc_id                    = module.vpc.vpc_id
  ssl_certificate_arn       = module.acm.ssl_certificate_arn
  zone_id                   = module.route53_zone.zone_id
  zone_name                 = module.route53_zone.zone_name
  private_subnet_ids        = module.vpc.private_subnet_ids
  public_subnet_ids         = module.vpc.public_subnet_ids
  beanstalk_sg_id           = module.sgs.beanstalk_sg_id
  db_host                   = local.db_host
  db_port                   = var.db_port
  db_name                   = module.secrets.db_name
  db_user                   = module.secrets.db_username
  db_password               = module.secrets.db_password
  alb_sg_id                 = module.sgs.alb_sg_id
  django_project_url        = var.django_project_url
  image_uri                 = module.ecr.ecr_repository_url
  image_tag                 = var.app_version
  repo_owner                = local.repo_owner
  repo_name                 = local.repo_name
  beanstalk_bucket_id       = module.s3.beanstalk_bucket_id
  branch_name               = var.branch_name
  image_build_status        = module.codebuild.image_build_status
  django_secret_key         = module.secrets.django_secret_key
  generic_tags              = local.generic_tags
}
