# Required Variables

variable "node_name" {
  type        = string
  description = "The name of the Proxmox node to use."
}

variable "vm_id" {
  type        = number
  description = "The VM ID to use for the new virtual machine."
}

variable "name" {
  type        = string
  description = "The name of the new virtual machine."
}

variable "default_network" {
  type = object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = string
  })
  description = "The default network configuration for the new virtual machine."
}

variable "bootdisk" {
  type = object({
    datastore_id   = optional(string, "local-lvm")
    file_id        = optional(string, null)
    import_from    = optional(string, null)
    interface_type = optional(string, "scsi")
    size           = optional(number, 20)
  })
  description = "The boot disk configuration for the new virtual machine."

  validation {
    condition     = (var.bootdisk.file_id != null) != (var.bootdisk.import_from != null)
    error_message = "Exactly one of file_id or import_from must be provided for the bootdisk."
  }
}

# Optional Variables

variable "description" {
  type        = string
  description = "The description for the new virtual machine."
  default     = "Managed by Terraform"
  nullable    = false
}

variable "tags" {
  type        = list(string)
  description = "A list of tags to assign to the new virtual machine."
  default     = []
  nullable    = false
}

variable "no_default_tags" {
  type        = bool
  description = "Whether to exclude default tags."
  default     = false
  nullable    = false
}

variable "pool_id" {
  type        = string
  description = "The ID of the Proxmox pool to assign the new virtual machine to."
  default     = ""
  nullable    = false
}

variable "started" {
  type        = bool
  description = "Whether the vm is started."
  default     = true
  nullable    = false
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to assign to the new virtual machine."
  default     = 2
  nullable    = false
}

variable "cpu_type" {
  type        = string
  description = "The CPU type to assign to the new virtual machine."
  default     = "kvm64"
  nullable    = false
}

variable "memory_mb" {
  type        = number
  description = "The amount of memory (in MB) to assign to the new virtual machine."
  default     = 2048
  nullable    = false
}

variable "additional_networks" {
  type = list(object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = optional(string, "")
  }))
  description = "A list of additional network configurations for the new virtual machine."
  default     = []
  nullable    = false
}

variable "additional_disks" {
  type = list(object({
    datastore_id   = optional(string, "local-lvm")
    interface_type = optional(string, "scsi")
    size           = number
  }))
  description = "A list of additional disk configurations for the VM."
  default     = []
  nullable    = false
}

variable "guest_agent" {
  type        = bool
  description = "Whether to enable the QEMU guest agent for the new virtual machine."
  default     = true
  nullable    = false
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "The ID of the Proxmox datastore to use for cloud-init configuration."
  default     = "local-lvm"
  nullable    = false
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS server addresses to assign to the new virtual machine."
  default     = []
}

variable "user_account" {
  type = object({
    ssh_keys = optional(list(string), [])
    username = optional(string, null)
    password = optional(string, null)
  })
  description = "The user account configuration for the new virtual machine. If username or password is provided, both must be provided."
  default     = null
}

variable "user_data_file_id" {
  type        = string
  description = "The ID of the cloud-init user data file."
  default     = null

  validation {
    condition     = var.user_data_file_id == null || var.user_account == null
    error_message = "If user_data_file_id is provided, cloud_init_datastore_id must also be provided."
  }
}

variable "vendor_data_file_id" {
  type        = string
  description = "The ID of the cloud-init vendor data file."
  default     = null
}

variable "upgrade" {
  type        = bool
  description = "Whether to perform a package upgrade on the new virtual machine during cloud-init."
  default     = true
}
