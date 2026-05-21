output "ipv4_addresses" {
  description = "IPv4 addresses per network device as reported by the QEMU guest agent."
  value       = proxmox_virtual_environment_vm.cloud_init_vm.ipv4_addresses
}
