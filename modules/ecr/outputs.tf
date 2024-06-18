output "ecr_repository_url" {
    value = aws_ecrpublic_repository.django_app.repository_uri
}

output "ecr_readiness" {
    value = null_resource.push_image_to_ecr
}