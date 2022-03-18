##############################################################################
# Public Load Balancer
##############################################################################

resource "ibm_is_lb" "pub_alb" {
  name            = "${var.hub_vpc_name}-vnf-alb"
  subnets         = ibm_is_subnet.hub_vnf_subnet[0].*.id
  resource_group  = data.ibm_resource_group.group.id
  security_groups = [ibm_is_security_group.pub_alb_security_group.id]
}

resource "ibm_is_lb_pool" "pub_alb_pool" {
  lb                 = ibm_is_lb.pub_alb.id
  name               = "${var.hub_vpc_name}-pub-alb-pool"
  protocol           = var.enable_end_to_end_encryption ? "https" : "http"
  algorithm          = "round_robin"
  health_delay       = "15"
  health_retries     = "2"
  health_timeout     = "5"
  health_type        = var.enable_end_to_end_encryption ? "https" : "tcp"
  health_monitor_url = "/"
  health_monitor_port = "22"
  #depends_on = [time_sleep.wait_30_seconds-1]
}

resource "ibm_is_lb_listener" "pub_alb_listner" {
  lb                   = ibm_is_lb.pub_alb.id
  port                 = var.certificate_crn == "" ? "80" : "443"
  protocol             = var.certificate_crn == "" ? "http" : "https"
  default_pool         = element(split("/", ibm_is_lb_pool.pub_alb_pool.id), 1)
  certificate_instance = var.certificate_crn == "" ? "" : var.certificate_crn
}

##############################################################################
# VNF Instance 1
##############################################################################
resource "ibm_is_instance" "pa-ha1" {
  name    = "pa-ha-instanca1"
  image   = ibm_is_image.vnf_custom_image.id
  profile        = "bx2-8x32"
  resource_group =  data.ibm_resource_group.group.id
  vpc       = ibm_is_vpc.hub_vpc.id
  zone      = "${var.region}-1"
  keys      = [data.ibm_is_ssh_key.sshkey.id]

  primary_network_interface {
    subnet          = ibm_is_subnet.hub_mgm_subnet[0].id
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    allow_ip_spoofing = true
  }
 network_interfaces {
    name   = "eth1"
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    subnet = ibm_is_subnet.hub_vnf_subnet[0].id
    allow_ip_spoofing = true
  }
 network_interfaces {
    name   = "eth2"
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    subnet = ibm_is_subnet.hub_onprem_subnet[0].id
    allow_ip_spoofing = true
  }
 network_interfaces {
    name   = "eth3"
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    subnet = ibm_is_subnet.hub_web_subnet[0].id
    allow_ip_spoofing = true
  }
    

  //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
resource "ibm_is_floating_ip" "pa-ha1-fip" {
  name   = "pa-ha1-floating-ip"
  target = ibm_is_instance.pa-ha1.primary_network_interface[0].id
}
resource "time_sleep" "wait_30_seconds" {
  depends_on = [ibm_is_lb.pub_alb]
 destroy_duration = "60s"
}
resource "ibm_is_lb_pool_member" "pub_alb_member1" {
  count = 1
  lb = "${ibm_is_lb.pub_alb.id}"
  pool ="${ibm_is_lb_pool.pub_alb_pool.id}"
  port  = 80
  target_address = "${ibm_is_instance.pa-ha1.network_interfaces[0].primary_ipv4_address}"
}
##############################################################################
# VNF Instance 2
##############################################################################
resource "ibm_is_instance" "pa-ha2" {
  name    = "pa-ha-instanca2"
  image   = ibm_is_image.vnf_custom_image.id
  profile        = "bx2-8x32"
  resource_group =  data.ibm_resource_group.group.id
  vpc       = ibm_is_vpc.hub_vpc.id
  zone      = "${var.region}-1"
  keys      = [data.ibm_is_ssh_key.sshkey.id]
  primary_network_interface {
    subnet          = ibm_is_subnet.hub_mgm_subnet[0].id
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    allow_ip_spoofing = true
  }
 network_interfaces {
    name   = "eth1"
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    subnet = ibm_is_subnet.hub_vnf_subnet[0].id
    allow_ip_spoofing = true
  }
 network_interfaces {
    name   = "eth2"
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    subnet = ibm_is_subnet.hub_onprem_subnet[0].id
    allow_ip_spoofing = true
  }
 network_interfaces {
    name   = "eth3"
    security_groups = [ibm_is_security_group.pub_alb_security_group.id]
    subnet = ibm_is_subnet.hub_web_subnet[0].id
    allow_ip_spoofing = true
  }
    

  //User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
resource "ibm_is_floating_ip" "pa-ha2-fip" {
  name   = "pa-ha2-floating-ip"
  target = ibm_is_instance.pa-ha2.primary_network_interface[0].id
}
resource "time_sleep" "wait_30_seconds-2" {
  depends_on = [ibm_is_lb.pub_alb]
  destroy_duration = "60s"
}
resource "ibm_is_lb_pool_member" "pub_alb_member2" {
  count = 1
  lb = "${ibm_is_lb.pub_alb.id}"
  pool ="${ibm_is_lb_pool.pub_alb_pool.id}"
  port  = 80
  target_address = "${ibm_is_instance.pa-ha2.network_interfaces[0].primary_ipv4_address}"
}
