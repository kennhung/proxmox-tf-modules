module "cloud_init_vm" {
  source = "../../"

  node_name = var.node_name
  vmid      = var.vmid

  name = "cloud-init-vm-simple-example"

  cpu_cores = 2
  memory_mb = 1024

  default_network = {
    bridge_name  = var.bridge_name
    ipv4_address = var.ipv4_address
    ipv4_gateway = var.ipv4_gateway
  }

  dns_servers = [var.ipv4_gateway]

  bootdisk = {
    datastore_id = var.bootdisk_datastore_id
    file_id      = var.bootdisk_file_id
  }

  cloud_init_datastore_id = var.cloud_init_datastore_id
}
