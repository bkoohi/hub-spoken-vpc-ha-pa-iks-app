
##############################################################################
# Create IKS cluster
##############################################################################
resource "ibm_container_vpc_cluster" "nonprod_iks_vpc" {
  depends_on = [ibm_is_vpc.spoke_nonprod_vpc]
  name              = var.cluster_name
  vpc_id            = ibm_is_vpc.spoke_nonprod_vpc.id
  resource_group_id = data.ibm_resource_group.group.id
  flavor            = var.machine_type
  worker_count      = var.workers_per_zone //adds "x" amount of workers for each zone provisioned dynamically
  kube_version      = var.kube_version != "" ? var.kube_version : null
  wait_till         = "OneWorkerNodeReady"
  disable_public_service_endpoint = true
// Dynamic Zone Provisioning per subnet in list
  dynamic "zones" {
    for_each = ibm_is_subnet.nonprod_iks_subnet
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }
}
#data "ibm_container_alb" "iprivate-alb1" {
#  alb_id = ibm_container_vpc_cluster.iks_nonprod_vpc.albs[0].id
#}
#resource "ibm_container_alb" "iprivate-alb1-1" {
#  alb_id = element(ibm_container_vpc_cluster.iks_nonprod_vpc.albs,0).id
#  enable = true
#}
#output "iks" {
#value = ibm_container_vpc_cluster.nonprod_iks_vpc.albs.*
#}
#output "alb1"{
#value = data.ibm_container_alb.iprivate-alb1.id
#}
