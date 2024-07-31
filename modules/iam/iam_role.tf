locals {
  assume_ebs_role_policy = jsondecode(file("${path.module}/json/iam_role_policy.json"))
  assume_ebs_policy = jsondecode(file("${path.module}/json/iam_policy.json"))
  assume_ebs_ec2_role = jsondecode(file("${path.module}/json/aws-elasticbeamstalk-ec2-role.json"))
}

resource "aws_iam_role" "ebslab_role" {
  name = var.role_name
  assume_role_policy = jsonencode(local.assume_ebs_role_policy)
  tags = var.generic_tags
}

resource "aws_iam_policy" "awseb_full_access" {
  name        = "AWSElasticBeanstalkFullAccess"
  description = "Provides full access to AWS Elastic Beanstalk"
  policy = jsonencode(local.assume_ebs_policy)
  tags = var.generic_tags
}

# Attach AWS Elastic Beanstalk policy
resource "aws_iam_role_policy_attachment" "ebslab_beanstalk_policy_attachment" {
  policy_arn = aws_iam_policy.awseb_full_access.arn
  role       = aws_iam_role.ebslab_role.name
}

# Attach AWS EC2 policy
resource "aws_iam_role_policy_attachment" "ebslab_ec2_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.ebslab_role.name
}


resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "aws-elasticbeanstalk-ec2-role"
  assume_role_policy = jsonencode(local.assume_ebs_ec2_role)
}

resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_worker_tier" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_multicontainer_docker" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}


resource "aws_iam_policy" "kms_usage_policy" {
  name        = "KMSUsagePolicy"
  description = "Allow use of the KMS key"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource  = var.kms_key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = aws_iam_policy.kms_usage_policy.arn
}