resource "proxmox_virtual_environment_container" "ubuntu_container" {
  node_name = var.node_name
  vm_id     = var.vm_id

  description = var.description
  tags        = var.no_default_tags ? var.tags : concat(["terraform", "lxc"], var.tags)
  pool_id     = var.pool_id
  protection  = var.protection

  start_on_boot = var.started
  started       = var.started

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  unprivileged = !var.privileged
  features {
    nesting = var.nesting ? true : null
    mount   = var.nfs ? ["nfs"] : null
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.default_network.ipv4_address
        gateway = var.default_network.ipv4_address == "dhcp" ? null : var.default_network.ipv4_gateway
      }
    }

    dynamic "ip_config" {
      for_each = { for idx, net in var.additional_networks : idx => net }

      content {
        ipv4 {
          address = ip_config.value.ipv4_address
          gateway = ip_config.value.ipv4_address == "dhcp" ? null : ip_config.value.ipv4_gateway
        }
        ipv6 {
          address = "dhcp"
        }
      }
    }

    user_account {
      keys     = var.ssh_keys
      password = var.password
    }

    dns {
      servers = var.dns_servers
    }
  }

  network_interface {
    name   = "eth0"
    bridge = var.default_network.bridge_name
  }

  dynamic "network_interface" {
    for_each = var.additional_networks

    content {
      name   = "eth${network_interface.key + 1}"
      bridge = network_interface.value.bridge_name
    }
  }

  disk {
    datastore_id = var.bootdisk.datastore_id
    size         = var.bootdisk.size
  }

  dynamic "mount_point" {
    for_each = var.mount_points
    content {
      volume = mount_point.value.volume
      path   = mount_point.value.path
      size   = mount_point.value.size
    }
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "ubuntu"
  }
}
