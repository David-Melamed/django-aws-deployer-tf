resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"
  assume_role_policy = jsonencode(local.assume_codebuild_role_policy_file)
  tags = var.generic_tags
}

resource "aws_iam_role_policy_attachment" "codebuild_role_ecr_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicPowerUser"
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "codebuild_policy"
  role = aws_iam_role.codebuild_role.id
  policy  = jsonencode(local.assume_codebuild_policy_file)
}

