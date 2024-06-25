data "aws_caller_identity" "current" {}

locals {
  build_project_name = aws_codebuild_project.build_project.name
  build_id = data.external.build_id.result.build_id
  image_build_status = data.external.image_build_status.result.image_build_status == "true"
}

resource "null_resource" "trigger_validate_source" {
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${aws_codebuild_project.validate_source.name}"
  }

  depends_on = [
    aws_codebuild_project.validate_source
  ]
}

resource "null_resource" "trigger_build_project" {
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${local.build_project_name}"
  }

  depends_on = [
    aws_codebuild_project.build_project,
    aws_codebuild_project.validate_source,
    null_resource.trigger_validate_source
  ]
}

data "external" "build_id" {
  program = [
    "bash", "-c",
    <<EOT
    BUILD_ID=$(aws codebuild start-build --project-name ${local.build_project_name} --query 'build.id' --output text)
    echo '{"build_id": "'$BUILD_ID'"}'
    EOT
  ]
}

data "external" "image_build_status" {
  program = [
    "bash", "${path.module}/scripts/check_build_status.sh", local.build_project_name, local.build_id
  ]
}