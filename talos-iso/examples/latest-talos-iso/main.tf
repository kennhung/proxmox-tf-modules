variable "proxmox_node_name" {
  type = string
}

module "latest_talos_iso" {
  source = "../.."

  proxmox_node_name = var.proxmox_node_name
}
