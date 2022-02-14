provider "ibm" {
  region           = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

resource "null_resource" "mkdir_kubeconfig_dir" {
  triggers = { always_run = timestamp() }
  provisioner "local-exec" {
    command = "mkdir -p ${local.cluster_config_path}"
  }
}

data "ibm_container_cluster_config" "cluster_config" {
  depends_on = [null_resource.mkdir_kubeconfig_dir]
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = local.cluster_config_path
}


// Module:
module "cp4aiops" {
  source    = "../../modules/cp4aiops"
  enable    = true
  cluster_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path
  on_vpc              = var.on_vpc
  portworx_is_ready   = 1          // Assuming portworx is installed if using VPC infrastructure

  // Entitled Registry parameters:
  entitlement_key        = var.entitled_registy_key
  entitled_registry_user = var.entitled_registry_user_email

  // AIOps specific parameters:
  cp4aiops_namespace     = var.cp4aiops_namespace

  ibmcloud_api_key = var.ibmcloud_api_key
//  entitlement_key = var.entitlement_key
//  entitled_registry_user = var.entitled_registry_user
}
