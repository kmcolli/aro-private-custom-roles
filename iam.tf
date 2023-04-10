data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

resource "azurerm_resource_provider_registration" "aro_udr" {
  name = "Microsoft.RedHatOpenShift"

  feature {
    name       = "UserDefinedRouting"
    registered = true
  }
}


# Needed so we can assign it the 'Network Contributor' role on the created VNet
data "azuread_service_principal" "aro_resource_provisioner" {
    display_name            = "Azure Red Hat OpenShift RP"
 }

resource "azuread_application" "cluster" {
    display_name            = "${local.name_prefix}-cluster-app"
    owners                  = [data.azuread_client_config.current.object_id]
}

# Create a new SP
resource "azuread_service_principal" "cluster" {
  application_id = azuread_application.cluster.application_id
  owners          = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "cluster" {
  service_principal_id = azuread_service_principal.cluster.id
}

resource "azuread_application_password" "cluster" {
    application_object_id   = azuread_application.cluster.object_id
}

resource "azurerm_role_assignment" "cluster" {
        scope                   = data.azurerm_subscription.current.id
        role_definition_name    = var.rp_role
        principal_id            = azuread_service_principal.cluster.object_id
}

resource "azurerm_role_assignment" "vnet" {
    scope                   = azurerm_virtual_network.main.id
    role_definition_name    = var.vnet_role
    principal_id            = data.azuread_service_principal.aro_resource_provisioner.object_id
}

