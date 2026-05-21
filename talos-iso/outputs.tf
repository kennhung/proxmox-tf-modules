output "file_id" {
  description = "The ID of the downloaded Talos image file."
  value       = proxmox_download_file.this.id
}
