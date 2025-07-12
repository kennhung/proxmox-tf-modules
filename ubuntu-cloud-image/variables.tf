variable "cloud_image_repository_url" {
  type        = string
  description = "URL for Ubuntu Cloud Images. Defaults to the official Ubuntu Cloud Images repository."
  default     = "https://cloud-images.ubuntu.com"
}

variable "ubuntu_version" {
  type        = string
  description = "The version of the Ubuntu image to download."
}

variable "architecture" {
  type        = string
  description = "The architecture of the Ubuntu image to download. Defaults to 'amd64'."
  default     = "amd64"
}

variable "serial" {
  type        = string
  description = "The serial of the Ubuntu image. Defaults to an empty string, which means the latest build will be used."
  default     = ""
}

variable "node_name" {
  type        = string
  description = "The name of the Proxmox node where the image will be downloaded."
}

variable "datastore_id" {
  type        = string
  description = "The ID of the Proxmox datastore where the image will be stored."
}
