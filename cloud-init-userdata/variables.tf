# Required Variables

variable "proxmox_node_name" {
  type        = string
  description = "The name of the Proxmox node to use for storing the cloud-init user data file."
}

variable "name" {
  type        = string
  description = "The name of the cloud-init user data file to create."
}

# Optional Variables

variable "proxmox_datastore_id" {
  type        = string
  description = "The ID of the Proxmox datastore to use for storing the cloud-init user data file."
  default     = "local"
  nullable    = false
}

variable "userdata_hostname" {
  type        = string
  description = "The hostname to set in the cloud-init user data file."
  default     = ""
  nullable    = false
}

variable "userdata_ssh_key" {
  type        = string
  description = "The SSH public key to add to the cloud-init user data file for the specified user."
  default     = ""
  nullable    = false
}

variable "userdata_ssh_import_id" {
  type        = string
  description = "The SSH import ID to use for importing SSH keys into the cloud-init user data file."
  default     = ""
  nullable    = false
}

variable "userdata_username" {
  type        = string
  description = "The username to create in the cloud-init user data file."
  default     = "cmsrobotics"
  nullable    = false
}

variable "userdata_password" {
  type        = string
  description = "The password to set for the specified user in the cloud-init user data file. Note: This is not recommended for production use."
  default     = ""
  nullable    = false
}

variable "userdata_ssh_pwauth" {
  type        = bool
  description = "Whether to enable SSH password authentication in the cloud-init user data file."
  default     = false
  nullable    = false
}

variable "userdata_additional_packages" {
  type        = list(string)
  description = "A list of additional packages to install in the cloud-init user data file."
  default     = []
  nullable    = false
}

variable "userdata_apt_mirror" {
  type        = string
  description = "The APT mirror to use in the cloud-init user data file."
  default     = ""
  nullable    = false
}
