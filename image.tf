##############################################################################
# Default ssh key
##############################################################################
data "ibm_is_ssh_key" "sshkey" {
  name = var.ssh_keyname
}

##############################################################################
# Default resource group
##############################################################################
data "ibm_resource_group" "group" {
  name = var.resource_group_name
}
##############################################################################
# VNF custom image
##############################################################################
# Generating random ID
resource "random_uuid" "test" { }

resource "ibm_is_image" "vnf_custom_image" {
  depends_on       = [random_uuid.test]
  href             = var.vnf_cos_image_url
  name             = "${var.hub_vpc_name}-vnf-${substr(random_uuid.test.result,0,8)}"
  operating_system = "ubuntu-18-04-amd64"
  resource_group     = data.ibm_resource_group.group.id

  timeouts {
    create = "30m"
    delete = "10m"
  }
}
##############################################################################
# Default Linux image
##############################################################################
data "ibm_is_image" "image" {
  name = "ibm-ubuntu-18-04-1-minimal-amd64-2"
}


