variable "node_name" {}

variable "vm_id" {}

variable "bridge" {}

variable "address" {}

variable "gw" {}

variable "template_file_id" {}

module "ubuntu_container" {
  source = "../.."

  node_name = var.node_name
  vm_id     = var.vm_id
  hostname  = "ubuntu-container"

  default_network = {
    bridge_name  = var.bridge
    ipv4_address = var.address
    ipv4_gateway = var.gw
  }

  template_file_id = var.template_file_id
}
