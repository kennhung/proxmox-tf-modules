
module "ubuntu_image" {
  count = var.cloud_image_file_id != "" ? 0 : 1

  source = "../ubuntu-cloud-image"

  node_name    = var.node_name
  datastore_id = var.cloud_image_datastore_id

  ubuntu_version = "24.04"
}

resource "random_password" "ubuntu_password" {
  count = var.ubuntu_password != "" ? 0 : 1

  length = 12
}

locals {
  ubuntu_password     = var.ubuntu_password != "" ? var.ubuntu_password : random_password.ubuntu_password[0].result
  cloud_image_file_id = var.cloud_image_file_id != "" ? var.cloud_image_file_id : module.ubuntu_image[0].file_id
}

module "ubuntu_vm" {
  source = "../cloud-init-vm"

  node_name = var.node_name
  vmid      = var.vmid
  name      = var.name

  cpu_cores = var.cpu_cores
  memory_mb = var.memory_mb

  bootdisk = {
    datastore_id = var.bootdisk_datastore_id
    file_id      = local.cloud_image_file_id
  }

  default_network = {
    bridge_name  = var.network_bridge
    ipv4_address = var.ipv4_address
    ipv4_gateway = var.ipv4_gateway
  }

  dns_servers = var.dns_servers

  cloud_init_datastore_id = var.cloud_init_datastore_id != "" ? var.cloud_init_datastore_id : var.bootdisk_datastore_id

  password = local.ubuntu_password
}
