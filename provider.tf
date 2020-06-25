variable "ibmcloud_api_key" {}
variable "iaas_region" {}
variable "iaas_classic_username" {}
variable "iaas_classic_api_key" {}
variable "iaas_datacenter" {}

// IBM Cloud IaaS regions:
// Dallas 	us-south 	us-south.iaas.cloud.ibm.com
// Frankfurt 	eu-de 	eu-de.iaas.cloud.ibm.com
// London 	eu-gb 	eu-gb.iaas.cloud.ibm.com
// Washington DC 	us-east 	us-east.iaas.cloud.ibm.com

provider "ibm" {
  ibmcloud_api_key   = var.ibmcloud_api_key
  generation         = 1
  region             = var.iaas_region
  iaas_classic_username = var.iaas_classic_username
  iaas_classic_api_key  = var.iaas_classic_api_key
}