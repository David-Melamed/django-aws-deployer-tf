output "codebuild_project_name" {
  value = aws_codebuild_project.build_project.name
}

output "ecr_repository_dns" {
  value = local.ecr_repository_dns
}
output "ecr_repository_id" {
  value = local.ecr_repository_id
}
