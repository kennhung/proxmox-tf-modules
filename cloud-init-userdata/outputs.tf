output "file_id" {
  description = "The ID of the uploaded cloud-init user data file."
  value       = proxmox_virtual_environment_file.cloud_init_userdata.id
}
