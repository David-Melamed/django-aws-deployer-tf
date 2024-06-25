resource "aws_codebuild_project" "validate_source" {
  depends_on = [ 
    aws_s3_bucket_policy.public_access_policy,
    aws_s3_bucket_acl.s3_bucket_acl,
    aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership 
  ]

  name          = "${var.pipeline_name}-validate-source"
  service_role  = var.codebuild_role_arn

  source {
    type = "NO_SOURCE"
    buildspec = file("${path.module}/specs/validatespec.yml")
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }
}

resource "aws_codebuild_project" "build_project" {
  depends_on = [ 
    aws_s3_bucket_policy.public_access_policy,
    aws_s3_bucket_acl.s3_bucket_acl,
    aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership 
  ]
  
  name          = "${var.pipeline_name}-build-source"
  service_role  = var.codebuild_role_arn  
  
  source {
    type = "NO_SOURCE"
    buildspec = file("${path.module}/specs/buildspec.yml")
    
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
  
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repository_name
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = var.app_version
    }
    environment_variable {
      name  = "DJANGO_URL"
      value = var.django_project_url
    }
    environment_variable {
        name = "ECR_REPO_ID"
        value = local.ecr_repository_id
    }
    environment_variable {
        name = "ECR_REPO_URL"
        value = "${local.ecr_repository_dns}/${local.ecr_repository_id}"
    }
    environment_variable {
        name = "AWS_ECR_REGION"
        value = var.ecr_region
    }
    environment_variable {
        name = "DOCKERFILE_S3_URL"
        value = "https://${var.bucket_regional_domain_name}/${aws_s3_object.dockerfile.key}"
    }
    environment_variable {
        name = "DOCKER_USERNAME"
        value = var.docker_username
    }
    environment_variable {
        name = "DOCKER_PASSWORD"
        value = var.docker_password
    }
  }
}

locals {
  ecr_repository_url = var.ecr_repository_url
  ecr_repository_parts = split("/", local.ecr_repository_url)
  ecr_repository_dns = element(local.ecr_repository_parts, 0)
  ecr_repository_id = element(local.ecr_repository_parts, 1)

}
