data "aws_caller_identity" "current" {}


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
    command = "aws codebuild start-build --project-name ${aws_codebuild_project.build_project.name}"
  }

  depends_on = [
    aws_codebuild_project.build_project
  ]
}