output "cloud_image_url" {
  description = "The URL of the Ubuntu cloud image."
  value       = local.cloud_image_url
}

output "cloud_image_checksum" {
  description = "The checksum of the Ubuntu cloud image."
  value       = local.cloud_image_checksum
}

output "cloud_image_serial" {
  description = "The build serial of the Ubuntu cloud image."
  value       = local.cloud_image_serial
}

output "file_id" {
  description = "The file ID of the downloaded Ubuntu cloud image."
  value       = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
}
