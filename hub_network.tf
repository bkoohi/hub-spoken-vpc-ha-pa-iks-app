
##############################################################################
# Management subets
##############################################################################
resource "ibm_is_subnet" "hub_mgm_subnet" {
  count                    = 3
  name                     = "${var.hub_vpc_name}-hub-mgm-subnet-${count.index + 1}"
  vpc                      = ibm_is_vpc.hub_vpc.id
  zone                     = "${var.region}-${count.index + 1}"
  resource_group           = data.ibm_resource_group.group.id
  total_ipv4_address_count = "256"
}

##############################################################################
# on-prem subets
##############################################################################
resource "ibm_is_subnet" "hub_onprem_subnet" {
  count                    = 3
  name                     = "${var.hub_vpc_name}-hub-onprem-subnet-${count.index + 1}"
  vpc                      = ibm_is_vpc.hub_vpc.id
  zone                     = "${var.region}-${count.index + 1}"
  resource_group           = data.ibm_resource_group.group.id
  total_ipv4_address_count = "256"
}

##############################################################################
# Web application internal subets
##############################################################################
resource "ibm_is_subnet" "hub_web_subnet" {
  count                    = 3
  name                     = "${var.hub_vpc_name}-hub-web-subnet-${count.index + 1}"
  vpc                      = ibm_is_vpc.hub_vpc.id
  zone                     = "${var.region}-${count.index + 1}"
  resource_group           = data.ibm_resource_group.group.id
  total_ipv4_address_count = "256"
}

##############################################################################
# VNF Public facing subets
##############################################################################
resource "ibm_is_subnet" "hub_vnf_subnet" {
  count                    = 3
  name                     = "${var.hub_vpc_name}-hub-vnf-subnet-${count.index + 1}"
  vpc                      = ibm_is_vpc.hub_vpc.id
  zone                     = "${var.region}-${count.index + 1}"
  resource_group           = data.ibm_resource_group.group.id
  total_ipv4_address_count = "256"
}
