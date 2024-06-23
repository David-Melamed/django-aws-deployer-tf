output "role_arn" {
  value = aws_iam_role.ebslab_role.arn
}

output "pipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}