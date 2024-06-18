# resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
#   repository = aws_ecrpublic_repository.django_app.repository_name

#   policy = <<EOF
# {
#     "rules": [
#         {
#             "rulePriority": 1,
#             "description": "Expire images older than 1 days",
#             "selection": {
#                 "tagStatus": "untagged",
#                 "countType": "sinceImagePushed",
#                 "countUnit": "days",
#                 "countNumber": 1
#             },
#             "action": {
#                 "type": "expire"
#             }
#         }
#     ]
# }
# EOF
# }