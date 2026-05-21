locals {
  base_url            = "${var.cloud_image_mirror}/releases/${var.ubuntu_version}/release${var.build_serial != "" ? "-${var.build_serial}" : ""}"
  checksum_filename   = "SHA256SUMS"
  build_info_filename = "unpacked/build-info.txt"
  image_filename      = "ubuntu-${var.ubuntu_version}-server-cloudimg-${var.architecture}.img"

  build_info_url = "${local.base_url}/${local.build_info_filename}"
}

data "external" "image_build_info" {
  program = ["bash", "${path.module}/get_build_info.sh"]

  query = {
    url = local.build_info_url
  }
}

data "external" "image_checksum" {
  program = ["bash", "${path.module}/get_checksum.sh"]

  query = {
    url   = "${local.base_url}/${local.checksum_filename}"
    image = local.image_filename
  }
}

locals {
  cloud_image_url      = "${local.base_url}/${local.image_filename}"
  cloud_image_checksum = data.external.image_checksum.result.checksum
  build_serial         = data.external.image_build_info.result.serial
}

resource "proxmox_download_file" "ubuntu_cloud_image" {
  content_type        = "import"
  overwrite           = true
  overwrite_unmanaged = false

  url       = local.cloud_image_url
  file_name = "ubuntu-${var.ubuntu_version}-${local.build_serial}-server-cloudimg-${var.architecture}.qcow2"

  checksum           = local.cloud_image_checksum
  checksum_algorithm = "sha256"

  datastore_id = var.datastore_id
  node_name    = var.proxmox_node_name
}
