# Separate null_resource for deleting repository with --force
resource "null_resource" "delete_ecr_repository" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      REPO_NAME=${self.triggers.repository_name}
      REGION=${self.triggers.region}
      bash ${path.module}/scripts/cleanup_ecr_repository.sh $REPO_NAME $REGION
    EOT
  }

  triggers = {
    repository_name = local.repository_name
    region          = var.ecr_region
  }
}