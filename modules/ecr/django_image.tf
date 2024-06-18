locals {
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}


resource "aws_ecrpublic_repository" "django_app" {
    repository_name = "${var.app_name}_${var.env}"
    provider        = aws.us_east_1

  catalog_data {
    description = "ECR Public for Django Application"
  }
  
  depends_on = [ var.image_tag ]
}


resource "null_resource" "build_image" {
    provisioner "local-exec" {
        command = <<EOF
        bash ${path.module}/scripts/docker-build.sh ${var.app_name}_${var.env} ${var.image_tag} ${aws_ecrpublic_repository.django_app.repository_uri} ${abspath(path.root)} ${var.image_platform} ${var.django_project_url}
        EOF
    }

triggers = {
  image_tag = var.image_tag
  }
}

resource "null_resource" "push_image_to_ecr" {
  depends_on = [null_resource.build_image]

    provisioner "local-exec" {
        command = <<EOF
        bash ${path.module}/scripts/docker-push.sh ${local.region} ${aws_ecrpublic_repository.django_app.repository_uri} ${var.image_tag}
    EOF
  }

triggers = {
    image_tag = var.image_tag
  }
}


