variable "vmid" {}

variable "name" {}

variable "node_name" {}

variable "ip_addr" {}

variable "gw" {}

variable "file_id" {}

module "ubuntu_vm" {
  source = "../.."

  node_name = var.node_name

  vm_id = var.vmid
  name  = var.name

  cpu_cores = 2
  memory_mb = 2048

  default_network = {
    bridge_name  = "vmbr0"
    ipv4_address = var.ip_addr
    ipv4_gateway = var.gw
  }

  bootdisk = {
    datastore_id = "local-lvm"
    file_id      = var.file_id
    size         = 20
  }
}
