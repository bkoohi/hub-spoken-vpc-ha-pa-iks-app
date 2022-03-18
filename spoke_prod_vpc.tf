
locals {
  subnets_cidr = [
    "10.240.0.0/24",
    "10.240.64.0/24",
    "10.240.128.0/24"
  ]
}

##############################################################################
# Default resource group
##############################################################################
#data "ibm_resource_group" "group" {
#  name = var.resource_group_name
#}
##############################################################################
# Default VPC
##############################################################################
resource "ibm_is_vpc" "spoke_prod_vpc" {
  name           = var.spoke_prod_vpc_name
  resource_group = data.ibm_resource_group.group.id
  address_prefix_management = "manual"
}
resource "ibm_is_vpc_address_prefix" "prod-prefix1" {
  name = "prod-address-prefix1"
  zone = "ca-tor-1"
  vpc  = ibm_is_vpc.spoke_prod_vpc.id
  cidr = "10.240.0.0/18"
}
resource "ibm_is_vpc_address_prefix" "prod-prefix2" {
  name = "prod-address-prefix2"
  zone = "ca-tor-2"
  vpc  = ibm_is_vpc.spoke_prod_vpc.id
  cidr = "10.240.64.0/18"
}
resource "ibm_is_vpc_address_prefix" "prod-prefix3" {
  name = "prod-address-prefix3"
  zone = "ca-tor-3"
  vpc  = ibm_is_vpc.spoke_prod_vpc.id
  cidr = "10.240.128.0/18"
}

##############################################################################
# Security Group for Public Load Balancer
##############################################################################

resource "ibm_is_security_group" "prod_iks_security_group" {
  name           = "${var.basename}-prod-iks-sg"
  vpc            = ibm_is_vpc.spoke_prod_vpc.id
  resource_group = data.ibm_resource_group.group.id
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_tcp_443" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_udp_443" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_tcp_22" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_tcp_80" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_icmp" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  icmp {
    type = 8
  }
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_tcp_80_outbound" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_tcp_443_outbound" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}
resource "ibm_is_security_group_rule" "prod_iks_security_group_rule_tcp_22_outbound" {
  group     = ibm_is_security_group.prod_iks_security_group.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}
