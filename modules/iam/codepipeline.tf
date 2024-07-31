locals {
  assume_codepipeline_role_policy_file = jsondecode(file("${path.module}/json/codepipeline_role.json"))
  assume_codepipeline_polcy_file = jsondecode(file("${path.module}/json/codepipeline_policy.json"))
  assume_codebuild_role_policy_file = jsondecode(file("${path.module}/json/codebuild_role.json"))
  assume_codebuild_policy_file = jsondecode(file("${path.module}/json/codebuild_policy.json"))
  assume_codepipeline_custom_policy = jsondecode(file("${path.module}/json/codepipeline_custom_policy.json"))
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"
  assume_role_policy = jsonencode(local.assume_codepipeline_role_policy_file)
  tags = var.generic_tags
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode(local.assume_codepipeline_polcy_file)
}

# Attach Policies
resource "aws_iam_role_policy_attachment" "codestar_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeStarFullAccess"
  role       = aws_iam_role.codepipeline_role.name
}

resource "aws_iam_role_policy_attachment" "codepipeline_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
  role       = aws_iam_role.codepipeline_role.name
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.codepipeline_role.name
}

resource "aws_iam_role_policy_attachment" "Custom_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.codepipeline_role.name
}
