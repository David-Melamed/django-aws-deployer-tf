locals {
  env                = "dev"
  zone_name          = "awsdjangodeployer.com"
  app_version        = "1"
  rds_instance_class = "db.t3.micro"
  db_host            = "rds-${local.env}.${local.zone_name}"
  db_port            = "3306"
  image_platform     = "linux/amd64"
  ecr_region         = "us-east-1"
  repo_owner         = regex("https://github.com/([^/]+)/", var.django_project_url)[0]
  repo_name          = regex("https://github.com/[^/]+/([^/]+).git", var.django_project_url)[0]
}


module "s3" {
  source             = "./modules/s3"
  bucket_name        = "${var.app_name}-${local.env}"
  env                = local.env
  beanstalk_app_name = var.app_name
}

module "vpc" {
  source                  = "./modules/vpc"
  tags                    = "test1"
  instance_tenancy        = var.instance_tenancy
  vpc_cidr                = var.vpc_cidr
  public_sn_count         = var.public_sn_count
  public_cidrs            = var.public_cidrs
  rt_route_cidr_block     = var.rt_route_cidr_block
  sg_name                 = "${var.app_name}-${local.env}-sg"
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

module "sgs" {
  source = "./modules/sgs"
  vpc_id = module.vpc.vpc_id
}

module "secrets" {
  source      = "./modules/secrets"
  kms_alias   = "${var.app_name}-${local.env}-kms-alias-new"
  db_name     = "${var.app_name}-${local.env}"
  db_username = var.db_username
  db_password = var.db_password
}

module "iam" {
  source                               = "./modules/iam"
  kms_key_arn                          = module.secrets.kms_key_arn
  role_name                            = "${var.app_name}-${local.env}-role"
}

module "rds" {
  source                = "./modules/rds"
  allocated_storage     = var.allocated_storage
  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = local.rds_instance_class
  username              = module.secrets.db_username
  password              = module.secrets.db_password
  db_name               = module.secrets.db_name
  identifier            = "${var.app_name}-${local.env}"
  skip_final_snapshot   = var.skip_final_snapshot
  subnet_name           = module.vpc.sg_name
  subnet_ids            = module.vpc.subnet_ids
  vpc_security_group_id = module.sgs.beanstalk_sg_id
  vpc_id                = module.vpc.vpc_id
  instance_private_ips  = module.beanstalk.instance_private_ips
  private_subnet_ids    = module.vpc.private_subnet_ids
  public_subnet_ids     = module.vpc.public_subnet_ids
}

module "route53_zone" {
  source    = "./modules/route53/zone"
  zone_name = local.zone_name
  vpc_id    = module.vpc.vpc_id
}

module "route53_rds_record" {
  source          = "./modules/route53/rds_record"
  rds_record_name = "rds-${local.env}"
  zone_name       = module.route53_zone.zone_name
  rds_address     = module.rds.db_endpoint
  zone_id         = module.route53_zone.zone_id
}

module "route53_registered_domains" {
  source                = "./modules/route53/registered_domains"
  zone_name             = module.route53_zone.zone_name
  zone_id               = module.route53_zone.zone_id
  zone_web_name_servers = module.route53_zone.name_servers
}

module "acm" {
  source      = "./modules/acm"
  domain_name = module.route53_zone.zone_name
  zone_id     = module.route53_zone.zone_id
}

module "ecr" {
  source              = "./modules/ecr"
  app_name            = var.app_name
  image_tag           = local.app_version
  django_project_url  = var.django_project_url
  env                 = local.env
  image_platform      = local.image_platform
  ecr_region          = local.ecr_region
}

module "codepipeline" { 
  source              = "./modules/codepipeline"
  app_name            = var.app_name
  image_tag           = local.app_version
  django_project_url  = var.django_project_url
  env                 = local.env
  image_platform      = local.image_platform
  ecr_region          = local.ecr_region
  pipeline_name       = "${var.app_name}-${local.env}"
  pipeline_role_arn   = module.iam.pipeline_role_arn
  s3_bucket_name      = "${var.app_name}-${local.env}"
  stage_version       = local.app_version
  codebuild_role_arn  = module.iam.codebuild_role_arn
  ecr_repository_name = module.ecr.ecr_repository_name
  app_version         = local.app_version
  repo_owner          = local.repo_owner
  repo_name           = local.repo_name
  beanstalk_bucket_id = module.s3.beanstalk_bucket_id
  ecr_repository_url  = module.ecr.ecr_repository_url
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
}

module "beanstalk" {
  source                    = "./modules/beanstalk"
  ebs_app_name              = var.app_name
  ebs_app_description       = var.ebs_app_description
  solution_stack_name       = var.solution_stack_name
  env                       = local.env
  service_role_name         = var.service_role_name
  instance_type             = var.instance_type
  bucket_name               = "${var.app_name}-${local.env}-${local.app_version}-bucket"
  application_version       = local.app_version
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
  db_port                   = local.db_port
  db_name                   = module.secrets.db_name
  db_user                   = module.secrets.db_username
  db_password               = module.secrets.db_password
  alb_sg_id                 = module.sgs.alb_sg_id
  django_project_url        = var.django_project_url
  image_uri                 = module.ecr.ecr_repository_url
  image_tag                 = local.app_version
  repo_owner                = local.repo_owner
  repo_name                 = local.repo_name
  beanstalk_bucket_id       = module.s3.beanstalk_bucket_id
  branch_name               = var.branch_name
  image_build_status        = module.codepipeline.image_build_status
}
