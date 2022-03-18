resource "ibm_tg_gateway" "auto_tg_gw"{
  name           = "${var.basename}-tgw"
  location=var.region
  resource_group = data.ibm_resource_group.group.id
  global=true
}  
resource "ibm_tg_connection" "prod_vpc_tg_connection1" {
  gateway      = ibm_tg_gateway.auto_tg_gw.id
  network_type = "vpc"
  name         = "spoke-prod-connection1"
  network_id   = ibm_is_vpc.spoke_prod_vpc.resource_crn
  depends_on = [ibm_is_vpc.spoke_prod_vpc]
}
resource "ibm_tg_connection" "nonprod_vpc_tg_connection2" {
  gateway      = ibm_tg_gateway.auto_tg_gw.id
  network_type = "vpc"
  name         = "spoke-nonprod-connection2"
  network_id   = ibm_is_vpc.spoke_nonprod_vpc.resource_crn
  depends_on = [ibm_is_vpc.spoke_nonprod_vpc]
}
resource "ibm_tg_connection" "hub_vpc_tg_connectioan3" {
  gateway      = ibm_tg_gateway.auto_tg_gw.id
  network_type = "vpc"
  name         = "hub-connection3"
  network_id   = ibm_is_vpc.hub_vpc.resource_crn
  depends_on = [ibm_tg_gateway.auto_tg_gw]
}
