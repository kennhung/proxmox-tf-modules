
module "ubuntu_cloud_image" {
  source = "../../"

  node_name    = var.node_name
  datastore_id = var.datastore_id
  ubuntu_version = var.ubuntu_version
}
