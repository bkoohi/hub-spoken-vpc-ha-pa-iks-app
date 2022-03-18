#terraform {
#  required_providers {
#    ibm = {
#      source  = "IBM-Cloud/ibm"
#      version = ">= 1.12.0"
#    }
#  }
#  required_version = ">= 0.12"
#}
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "1.39.1"
    }
  }
}

#provider "ibm" {
#  # Configuration options
#}
