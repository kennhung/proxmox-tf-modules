module "ubuntu_haproxy" {
  source = "../../"

  node_name = var.node_name
  vmid      = var.vmid

  network_bridge = var.network_bridge
  ipv4_address   = var.ipv4_address
  ipv4_gateway   = var.ipv4_gateway
  dns_servers    = [var.ipv4_gateway]

  bootdisk_datastore_id = var.datastore_id

  ubuntu_password = "ubuntu"
}
