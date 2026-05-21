variable "node_name" {
  description = "The name of the Proxmox node where the image will be created."
  type        = string
}

module "latest_ubuntu_image" {
  source = "../.."

  proxmox_node_name = var.node_name
}
