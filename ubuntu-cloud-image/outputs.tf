output "file_id" {
  description = "The ID of the downloaded Ubuntu cloud image file."
  value       = proxmox_download_file.ubuntu_cloud_image.id
}
