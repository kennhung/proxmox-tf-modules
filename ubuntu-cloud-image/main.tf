locals {
  base_url = "${var.cloud_image_repository_url}/releases/${var.ubuntu_version}/release${var.serial != "" ? "-${var.serial}" : ""}"

  # Filenames
  checksum_filename   = "SHA256SUMS"
  build_info_filename = "unpacked/build-info.txt"
  image_filename      = "ubuntu-${var.ubuntu_version}-server-cloudimg-${var.architecture}.img"
}

data "external" "image_build_info" {
  program = ["bash", "${path.module}/scripts/get_build_info.sh"]

  query = {
    url = "${local.base_url}/${local.build_info_filename}"
  }
}

data "external" "image_checksum" {
  program = ["bash", "${path.module}/scripts/get_checksum.sh"]

  query = {
    url      = "${local.base_url}/${local.checksum_filename}"
    filename = local.image_filename
  }
}

locals {
  cloud_image_url      = "${local.base_url}/${local.image_filename}"
  cloud_image_checksum = data.external.image_checksum.result.checksum
  cloud_image_serial   = data.external.image_build_info.result.serial
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  depends_on = [
    data.external.image_build_info,
    data.external.image_checksum,
  ]

  content_type        = "iso"
  overwrite           = true
  overwrite_unmanaged = false

  url       = local.cloud_image_url
  file_name = "ubuntu-${var.ubuntu_version}-${local.cloud_image_serial}-server-cloudimg-${var.architecture}.img"

  checksum           = local.cloud_image_checksum
  checksum_algorithm = "sha256"

  datastore_id = var.datastore_id
  node_name    = var.node_name
}
