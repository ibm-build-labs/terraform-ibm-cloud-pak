variable "cluster_name_or_id" {
  description = "Id of cluster for AIOps to be installed on"
}

variable "ibmcloud_api_key" {
  description = "IBMCloud API key (https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)"
}

variable "region" {
  description = "Region that cluster resides in"
}

variable "resource_group_name" {
  default     = "cloud-pak-sandbox-ibm"
  description = "Resource group that cluster resides in"
}

variable "on_vpc" {
  default     = false
  type        = bool
  description = "If set to true, lets the module know cluster is using VPC Gen2"
}

variable "entitled_registry_key" {
  type        = string
  description = "Get the entitlement key from https://myibm.ibm.com/products-services/containerlibrary"
}

variable "entitled_registry_user_email" {
  type        = string
  description = "Docker email address"
}

variable "cluster_config_path" {
  default     = "./.kube/config"
  type        = string
  description = "Defaulted to `./.kube/config` but for schematics, use `/tmp/.schematic/.kube/config"
}

variable "accept_aiops_license" {
  default     = false
  type        = bool
  description = "Do you accept the aiops licensing? Default is `false`"
}