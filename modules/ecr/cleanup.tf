resource "aws_ecr_repository" "django_ecr_repo" {
  name = aws_ecrpublic_repository.django_app.repository_name
}

resource "null_resource" "cleanup_ecr_repo" {
  provisioner "local-exec" {
    command = "${path.module}/scripts/cleanup_ecr_repo.sh ${aws_ecr_repository.django_ecr_repo.name} ${var.ecr_region}"
  }

  triggers = {
    repo_name = aws_ecr_repository.django_ecr_repo.name
  }
}