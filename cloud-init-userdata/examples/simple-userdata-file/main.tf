variable "node_name" {}

module "simple_userdata_file" {
  source = "../../"

  proxmox_node_name = var.node_name
  name              = "simple"
  userdata_hostname = "ubuntu-vm"
}
