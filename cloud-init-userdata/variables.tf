variable "node_name" {
  type        = string
  description = "Name of the Proxmox node where the userdata file will be created."
}

variable "datastore_id" {
  type        = string
  description = "Datastore ID for the userdata file. Defaults to 'local'."
  default     = ""
}

variable "file_name" {
  type        = string
  description = "Name of the userdata file to be created."
}

variable "hostname" {
  type        = string
  description = "Hostname for the VM."
}

variable "username" {
  type        = string
  description = "Username for the Cloud-Init user. Defaults to 'ubuntu'."
  default     = "ubuntu"
}

variable "password" {
  type        = string
  description = "Password for the Cloud-Init user."
  default     = ""
  sensitive   = true
}

variable "ssh_key" {
  type        = string
  description = "SSH public key for the Cloud-Init user."
  default     = ""
}

variable "ssh_import_id" {
  type        = string
  description = "SSH import ID for the Cloud-Init user."
  default     = ""
}

variable "additional_packages" {
  type        = list(string)
  description = "List of additional packages to install."
  default     = []
}

variable "apt_mirror" {
  type        = string
  description = "APT mirror URL to use for package installation. Leave empty to use default mirrors."
  default     = ""
}
