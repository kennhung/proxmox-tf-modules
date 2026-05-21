# Required Variables
variable "proxmox_node_name" {
  description = "The name of the Proxmox node where the cloud image will be stored."
  type        = string
  nullable    = false
}

# Optional Variables
variable "cloud_image_mirror" {
  description = "The URL of the Ubuntu cloud image mirror."
  type        = string
  default     = "https://cloud-images.ubuntu.com"
  nullable    = false
}

variable "ubuntu_version" {
  description = "The version of the Ubuntu image to download."
  type        = string
  default     = null
}

variable "architecture" {
  description = "The architecture of the Ubuntu image to download."
  type        = string
  default     = "amd64"
  nullable    = false
}

variable "build_serial" {
  description = "The build serial number for the Ubuntu cloud image."
  type        = string
  default     = null
}

variable "datastore_id" {
  description = "The ID of the datastore where the cloud image will be stored."
  type        = string
  default     = "local"
  nullable    = false
}
