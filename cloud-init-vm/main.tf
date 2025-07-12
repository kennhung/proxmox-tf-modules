resource "proxmox_virtual_environment_vm" "proxmox_vm" {
  node_name = var.node_name
  vm_id     = var.vmid

  name        = var.name
  description = var.description
  tags        = ["terraform"]
  on_boot     = true
  migrate     = true

  started = var.started

  cpu {
    cores = var.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.memory_mb
  }

  agent {
    enabled = true
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
    file_format  = "raw"
    interface    = "scsi0"
    size         = var.bootdisk.size
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = var.cloud_init_datastore_id

    ip_config {
      ipv4 {
        address = var.default_network.ipv4_address
        gateway = var.default_network.ipv4_gateway
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
          gateway = ip_config.value.ipv4_gateway
        }
        ipv6 {
          address = "dhcp"
        }
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init_userdata.id
  }
}

resource "proxmox_virtual_environment_file" "cloud_init_userdata" {
  node_name    = var.node_name
  datastore_id = var.userdata_file_datastore_id
  content_type = "snippets"

  source_raw {
    data = templatefile("${path.module}/userdata.tftpl", {
      hostname = var.name

      username      = var.username
      password      = var.password
      ssh_key       = var.ssh_key
      ssh_import_id = var.ssh_import_id

      additional_packages = var.additional_packages
      apt_mirror          = var.apt_mirror
    })

    file_name = "${var.vmid}-userdata.yaml"
  }
}
