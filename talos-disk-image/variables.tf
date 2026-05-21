# Required Variables

variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node to use."
}

# Optional Variables

variable "proxmox_datastore_id" {
  type        = string
  description = "The ID of the Proxmox datastore to use."
  default     = "local"
  nullable    = false
}

variable "talos_version" {
  type        = string
  description = "Version of Talos to use for the image. For example, 'v1.3.0'. If not specified, the latest stable version will be used."
  default     = null
}

variable "talos_stable_versions_only" {
  type        = bool
  description = "Whether to only consider stable versions of Talos."
  default     = true
  nullable    = false
}

variable "talos_image_architecture" {
  type        = string
  description = "The architecture of the Talos image to download. For example, 'amd64' or 'arm64'."
  default     = "amd64"
  nullable    = false
}

variable "talos_image_platform" {
  type        = string
  description = "The platform of the Talos image to download."
  default     = "nocloud"
  nullable    = false
}

variable "secure_boot" {
  type        = bool
  description = "Whether to use a secure boot compatible image. This will select an image with the 'secureboot' extension if available."
  default     = false
  nullable    = false
}

variable "talos_image_extensions" {
  type        = list(string)
  description = "List of extensions to include in the Talos image."
  default = [
    "qemu-guest-agent",
    "siderolabs/iscsi-tools",
    "util-linux-tools"
  ]
  nullable = false
}
