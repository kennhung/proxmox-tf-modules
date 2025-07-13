resource "proxmox_virtual_environment_file" "cloud_init_userdata" {
  node_name    = var.node_name
  datastore_id = var.datastore_id == "" ? "local" : var.datastore_id
  content_type = "snippets"

  source_raw {
    data = templatefile("${path.module}/userdata.tftpl", {
      hostname = var.hostname

      username      = var.username
      password      = var.password
      ssh_key       = var.ssh_key
      ssh_import_id = var.ssh_import_id

      additional_packages = var.additional_packages
      apt_mirror          = var.apt_mirror
    })

    file_name = var.file_name
  }
}
