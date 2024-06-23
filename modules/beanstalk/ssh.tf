resource "null_resource" "prepare_directories" {

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ${path.root}/.platform/ssh
    EOT
  }
}

resource "null_resource" "copy_ssh_key" {
  depends_on = [null_resource.prepare_directories]

  provisioner "local-exec" {
    command = <<EOT
      cp ${var.ssh_public_key_local_path} ${path.root}/.platform/ssh/
    EOT
  }
}