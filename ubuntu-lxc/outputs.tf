output "ipv4" {
  description = "Map of IPv4 addresses per network interface (first address per device)."
  value       = proxmox_virtual_environment_container.ubuntu_container.ipv4
}

output "ipv6" {
  description = "Map of IPv6 addresses per network interface (first address per device)."
  value       = proxmox_virtual_environment_container.ubuntu_container.ipv6
}
