module "talos_image_url" {
  source = "github.com/kennhung/talos-terraform//modules/talos-image-url?ref=23b8d65"

  talos_version        = var.talos_version
  stable_versions_only = var.talos_stable_versions_only

  image_architecture = var.talos_image_architecture
  image_platform     = var.talos_image_platform
  image_extensions   = var.talos_image_extensions
}

locals {
  image_version      = module.talos_image_url.image_version
  image_schematic_id = module.talos_image_url.image_schematic_id
  image_platform     = module.talos_image_url.image_platform
  image_arch         = module.talos_image_url.image_architecture

  file_name = "${join("-", compact([
    "talos",
    local.image_version,
    local.image_schematic_id,
    local.image_platform,
    local.image_arch,
    var.secure_boot ? "secureboot" : null
  ]))}.iso"
}

resource "proxmox_download_file" "this" {
  datastore_id = var.proxmox_datastore_id
  node_name    = var.proxmox_node_name

  content_type        = "iso"
  overwrite           = true
  overwrite_unmanaged = false

  url       = module.talos_image_url.image_urls.disk_image
  file_name = local.file_name
}
