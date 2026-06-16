# Required Variables

variable "node_name" {
  type        = string
  description = "The name of the Proxmox node to use."
}

variable "vm_id" {
  type        = number
  description = "The VM ID to use for the new container."
}

variable "hostname" {
  type        = string
  description = "The hostname for the new container. Default is the same as the name of the container."
}

variable "default_network" {
  type = object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = string
  })
  description = "The default network configuration for the new container."
}

variable "template_file_id" {
  type        = string
  description = "The ID of the Proxmox template file to use for the new container. Required when not cloning."
  default     = null
}

variable "clone" {
  type = object({
    vm_id        = number
    node_name    = optional(string, null)
    datastore_id = optional(string, null)
  })
  description = "Clone an existing container instead of creating from a template. Mutually exclusive with template_file_id."
  default     = null
}

# Optional Variables

variable "description" {
  type        = string
  description = "The description for the new container."
  default     = "Managed by Terraform"
  nullable    = false
}

variable "tags" {
  type        = list(string)
  description = "A list of tags to assign to the new container."
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
  description = "The ID of the Proxmox pool to assign the new container to."
  default     = null
}

variable "started" {
  type        = bool
  description = "Whether the vm is started."
  default     = true
  nullable    = false
}

variable "protection" {
  type        = bool
  description = "Whether to enable protection on the container to prevent accidental deletion."
  default     = false
  nullable    = false
}

variable "privileged" {
  type        = bool
  description = "Whether to run the container in privileged mode."
  default     = false
  nullable    = false
}

variable "nesting" {
  type        = bool
  description = "Whether to enable nesting support in the container."
  default     = true
  nullable    = false
}

variable "nfs" {
  type        = bool
  description = "Whether to enable NFS mount support in the container."
  default     = false
  nullable    = false
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to assign to the new container."
  default     = 2
  nullable    = false
}

variable "memory_mb" {
  type        = number
  description = "The amount of memory (in MB) to assign to the new container."
  default     = 2048
  nullable    = false
}

variable "additional_networks" {
  type = list(object({
    bridge_name  = string
    ipv4_address = string
    ipv4_gateway = optional(string, "")
  }))
  description = "A list of additional network configurations for the new container."
  default     = []
  nullable    = false
}

variable "bootdisk" {
  type = object({
    datastore_id = optional(string, "local-lvm")
    size         = optional(number, 8)
  })
  description = "The boot disk configuration for the new container."
  default     = {}
  nullable    = false
}

variable "mount_points" {
  type = list(object({
    volume = optional(string, "local-lvm")
    path   = string
    size   = optional(string, null)
  }))
  description = "A list of additional mount points to attach to the container."
  default     = []
  nullable    = false
}

variable "password" {
  type        = string
  sensitive   = true
  description = "The password for the root user in the new container."
  default     = null
}

variable "ssh_keys" {
  type        = list(string)
  description = "A list of SSH public keys to add to the root user in the new container."
  default     = []
  nullable    = false
}

variable "dns_servers" {
  type        = list(string)
  description = "A list of DNS server addresses to assign to the new container."
  default     = null
}
