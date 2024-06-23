output "ecr_repository_url" {
    value = aws_ecrpublic_repository.django_app.repository_uri
}

output "ecr_repository_name" {
    value = aws_ecrpublic_repository.django_app.repository_name
}