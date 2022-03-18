
##############################################################################
# IKS application internal subets
##############################################################################
resource "ibm_is_subnet" "prod_iks_subnet" {
  depends_on = [ibm_is_vpc.spoke_prod_vpc]
  count                    = 3
  name                     = "${var.spoke_prod_vpc_name}-iks-subnet-${count.index + 1}"
  vpc                      = ibm_is_vpc.spoke_prod_vpc.id
  zone                     = "${var.region}-${count.index + 1}"
  resource_group           = data.ibm_resource_group.group.id
  ipv4_cidr_block = local.subnets_cidr[count.index]
#  ipv4_cidr_block         = "10.240.0.0/24"
#  ipv4_cidr_block         = "ibm_is_vpc_address_prefix.prefix${count.index +1}.cidr/24"
#  total_ipv4_address_count = "256"
  public_gateway  = element(ibm_is_public_gateway.spoke_prod_pgw.*.id, count.index)
}

resource "ibm_is_public_gateway" "spoke_prod_pgw" {
  depends_on = [ibm_is_vpc.spoke_prod_vpc]
  count 		   = 3
  name 			   = "${ibm_is_vpc.spoke_prod_vpc.name}-pwg--${count.index + 1}"
  vpc  			   = ibm_is_vpc.spoke_prod_vpc.id
  zone 			   = "${var.region}-${count.index + 1}"

  //User can configure timeouts
  timeouts {
    create = "90m"
  }
}
