output "ipv4_address" {
  description = "The HAProxy server's IP address."
  value       = module.ubuntu_lxc.ipv4["eth0"]
}
