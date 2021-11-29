locals {
<<<<<<< Updated upstream
  cp4ba_storage_class_file         = "${path.module}/files/cp4ba_storage_class.yaml"
  cp4ba_storage_class_file_content = file(local.cp4ba_storage_class_file)
  pvc_file                         = "${path.module}/files/operator_shared_pvc.yaml"
  pvc_file_content                 = file(local.pvc_file)
  catalog_source_file              = "${path.module}/files/catalog_source.yaml"
  catalog_source_file_content      = file(local.catalog_source_file)
  cp4ba_subscription_content = templatefile("${path.module}/templates/cp4ba_subscription.yaml.tmpl", {
    namespace = var.cp4ba_project_name,
  })
  automationUIConfig_content = templatefile("${path.module}/templates/automationUIConfig.yaml.tmpl", {
    namespace        = var.cp4ba_project_name,
  })
  cp4ba_deployment_content = templatefile("${path.module}/templates/cp4ba_deployment.yaml.tmpl", {
    ingress_subdomain = var.ingress_subdomain,
    ldap_host_ip      = var.ldap_host_ip,
    db2_host_name     = var.db2_host_name,
    db2_host_port     = var.db2_host_port
=======
  pvc_file                              = "${path.module}/files/operator-shared-pvc.yaml"
  pvc_file_content                      = file(local.pvc_file)
  operator_group_file                   = "${path.module}/files/operator-group.yaml"
  operator_group_file_content           = file(local.operator_group_file)
  catalog_source_file                   = "${path.module}/files/catalog_source.yaml"
  catalog_source_file_content           = file(local.catalog_source_file)
  roles_file                            = "${path.module}/files/roles.yaml"
  roles_file_content                    = file(local.roles_file)
  role_binding_file                     = "${path.module}/files/role_binding.yaml"
  role_binding_content                  = file(local.role_binding_file)
  cp4ba_subscription_file               = "${path.module}/files/cp4ba_subscription.yaml"
  cp4ba_subscription_file_content       = file(local.cp4ba_subscription_file)
  cp4ba_deployment_credentials_file     = "${path.module}/templates/cp4ba_deployment_credentials.yaml.tmpl"
  cp4ba_deployment_credentials_file_content = file(local.cp4ba_deployment_credentials_file)
  cp4ba_deployment_file_content             = templatefile("${path.module}/templates/cp4ba_deployment.yaml.tmpl", {
    ldap_host_ip     = var.ldap_host_ip,
    db2_admin        = var.db2_admin,
    db2_host_name    = var.db2_host_name,
    db2_host_port    = var.db2_host_port
>>>>>>> Stashed changes
  })

  secrets_content = templatefile("${path.module}/templates/secrets.yaml.tmpl", {
    ldap_admin    = var.ldap_admin,
    ldap_password = var.ldap_password,
    db2_admin     = var.db2_admin,
    db2_user      = var.db2_user,
    db2_password  = var.db2_password
  })
}

resource "null_resource" "installing_cp4ba" {
  count = var.enable ? 1 : 0

  triggers = {
    PVC_FILE_sha1                         = sha1(local.pvc_file_content)
<<<<<<< Updated upstream
    STORAGE_CLASS_FILE_sha1               = sha1(local.cp4ba_storage_class_file_content)
    CATALOG_SOURCE_FILE_sha1              = sha1(local.catalog_source_file_content)
    CP4BA_SUBSCRIPTION_FILE_sha1          = sha1(local.cp4ba_subscription_content)
    CP4BA_DEPLOYMENT_sha1                 = sha1(local.cp4ba_deployment_content)
    AUTOMATION_UICONFIG_sha1              = sha1(local.automationUIConfig_content)
    SECRET_sha1                           = sha1(local.secrets_content)
=======
    OPERATOR_GROUP_sha1                   = sha1(local.operator_group_file_content)
    CATALOG_SOURCE_FILE_sha1              = sha1(local.catalog_source_file_content)
    CP4BA_SUBSCRIPTION_FILE_sha1          = sha1(local.cp4ba_subscription_file_content)
    cp4ba_deployment_credentials_sha1     = sha1(local.cp4ba_deployment_credentials_file_content)
    CP4BA_DEPLOYMENT_sha1                 = sha1(local.cp4ba_deployment_file_content)
    SECRET_sha1                           = sha1(local.secrets_content)
    ROLES_sha1                            = sha1(local.roles_file_content)
    ROLE_BINDING_sha1                     = sha1(local.role_binding_content)
>>>>>>> Stashed changes
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/install_cp4ba.sh"

    environment = {
      # ---- Cluster ----
<<<<<<< Updated upstream
      #cluster_config_path           = var.cluster_config_path
=======
      KUBECONFIG                    = var.cluster_config_path
>>>>>>> Stashed changes

      # ---- Cloud Pak ----
      CP4BA_PROJECT_NAME            = var.cp4ba_project_name

      # ---- Registry Images ----
      ENTITLED_REGISTRY_EMAIL = var.entitled_registry_user
      ENTITLED_REGISTRY_KEY   = var.entitlement_key
      DOCKER_SERVER           = local.docker_server
      DOCKER_USERNAME         = local.docker_username

<<<<<<< Updated upstream
      # ------- Files --------
      CP4BA_STORAGE_CLASS_FILE      = local.cp4ba_storage_class_file
      OPERATOR_PVC_FILE             = local.pvc_file
      CATALOG_SOURCE_FILE           = local.catalog_source_file
      CP4BA_SUBSCRIPTION_CONTENT    = local.cp4ba_subscription_content
      CP4BA_DEPLOYMENT_CONTENT      = local.cp4ba_deployment_content
      AUTOMATIONUICONFIG_CONTENT    = local.automationUIConfig_content
      SECRETS_CONTENT               = local.secrets_content
=======
      # ------- FILES ASSIGNMENTS --------
      OPERATOR_PVC_FILE                = local.pvc_file
      OPERATOR_GROUP_FILE              = local.operator_group_file
      CATALOG_SOURCE_FILE              = local.catalog_source_file
      CP4BA_SUBSCRIPTION_FILE          = local.cp4ba_subscription_file
      CP4BA_DEPLOYMENT_CREDENTIALS_FILE = local.cp4ba_deployment_credentials_file
      CP4BA_DEPLOYMENT_CONTENT         = local.cp4ba_deployment_file_content
      SECRETS_CONTENT                  = local.secrets_content
      ROLES_FILE                       = local.roles_file
      ROLE_BINDING_FILE                = local.role_binding_file
>>>>>>> Stashed changes
    }
  }
}

data "external" "get_endpoints" {
  count = var.enable ? 1 : 0

  depends_on = [
    null_resource.installing_cp4ba
  ]

  program = ["/bin/bash", "${path.module}/scripts/get_endpoints.sh"]

  query = {
    kubeconfig = var.cluster_config_path
    namespace  = var.cp4ba_project_name
  }
}

