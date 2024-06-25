variable "codebuild_role_arn" {}
variable "app_name" {}          
variable "image_tag" {}         
variable "django_project_url" {}
variable "env" {} 
variable "image_platform" {}    
variable "ecr_region" {}        
variable "pipeline_name" {}
variable "pipeline_role_arn" {}
variable "s3_bucket_name" {}
variable "stage_version" {}
variable "ecr_repository_name" {}
variable "app_version" {}
variable "repo_owner" {}
variable "repo_name" {}
variable "beanstalk_bucket_id" {}
variable "ecr_repository_url" {}
variable "bucket_regional_domain_name" {}

variable "image_build_status" {
  description = "Flag to deploy Elastic Beanstalk environment"
  type        = bool
  default     = true
}   