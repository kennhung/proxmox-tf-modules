resource "proxmox_virtual_environment_file" "cloud_init_userdata" {
  content_type = "snippets"
  datastore_id = var.proxmox_datastore_id
  node_name    = var.proxmox_node_name

  source_raw {
    data = templatefile("${path.module}/userdata.tftpl", {
      hostname            = var.userdata_hostname
      username            = var.userdata_username
      ssh_key             = var.userdata_ssh_key
      ssh_import_id       = var.userdata_ssh_import_id
      password            = var.userdata_password
      ssh_pwauth          = var.userdata_ssh_pwauth
      additional_packages = var.userdata_additional_packages
      apt_mirror          = var.userdata_apt_mirror
    })

    file_name = "${var.name}-userdata.yaml"
  }
}
