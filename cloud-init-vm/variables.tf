variable "vmid" {
  type        = number
  description = "Proxmox VMID for the virtual machine."
}

variable "node_name" {
  type        = string
  description = "Name of the Proxmox node where the VM will be created."
}

variable "name" {
  type        = string
  description = "Name of the Proxmox VM."
}

variable "description" {
  type        = string
  description = "Description of the Proxmox VM."
  default     = "Managed by Terraform"
}

variable "started" {
  type        = bool
  description = "Whether to start the virtual machine."
  default     = true
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores for the VM."
}

variable "memory_mb" {
  type        = number
  description = "Amount of memory in MB for the VM."
}

variable "default_network" {
  type = object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = string
  })
  description = "Default network configuration for the VM."
}

variable "additional_networks" {
  type = list(object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = optional(string, "")
  }))
  description = "Additional network configurations for the VM."
  default     = []
}

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS servers for the VM. Defaults to node's DNS servers."
  default     = []
}

variable "bootdisk" {
  type = object({
    datastore_id = string
    file_id      = string
    size         = optional(number, 20)
  })
  description = "Configuration for the boot disk of the VM."
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "Datastore ID for the Cloud-Init configuration."
}

variable "userdata_file_datastore_id" {
  type        = string
  description = "Datastore ID for the userdata file."
  default     = ""
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
