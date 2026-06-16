resource "proxmox_virtual_environment_vm" "cloud_init_vm" {
  node_name = var.node_name
  vm_id     = var.vm_id

  name        = var.name
  description = var.description
  tags        = var.no_default_tags ? var.tags : concat(["terraform", "cloud-init"], var.tags)
  pool_id     = var.pool_id

  on_boot = var.started
  started = var.started

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.memory_mb
  }

  agent {
    enabled = var.guest_agent
  }

  network_device {
    bridge = var.default_network.bridge_name
  }

  dynamic "network_device" {
    for_each = { for idx, net in var.additional_networks : idx => net }

    content {
      bridge = network_device.value.bridge_name
    }
  }

  disk {
    datastore_id = var.bootdisk.datastore_id
    file_id      = var.bootdisk.file_id
    import_from  = var.bootdisk.import_from
    interface    = "${var.bootdisk.interface_type}0"
    size         = var.bootdisk.size
  }

  dynamic "disk" {
    for_each = var.additional_disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = "${disk.value.interface_type}${disk.key + 1}"
      size         = disk.value.size
    }
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = var.cloud_init_datastore_id
    upgrade      = var.upgrade

    ip_config {
      ipv4 {
        address = var.default_network.ipv4_address
        gateway = var.default_network.ipv4_address == "dhcp" ? null : var.default_network.ipv4_gateway
      }
      ipv6 {
        address = "dhcp"
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

    dns {
      servers = var.dns_servers
    }

    dynamic "user_account" {
      for_each = var.user_account != null ? [var.user_account] : []

      content {
        keys     = user_account.value.ssh_keys
        username = user_account.value.username
        password = user_account.value.password
      }
    }

    user_data_file_id   = var.user_data_file_id
    vendor_data_file_id = var.vendor_data_file_id
  }

  lifecycle {
    ignore_changes = [node_name, hostpci, disk[0].file_id]
  }
}
