locals {
  name_prefix = var.cluster_name
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location

}

#resource "azurerm_resource_group" "cluster" {
#  name     = "${local.name_prefix}-cluster-rg"
#  location = var.location
#}

resource "azurerm_resource_group" "vnet" {
  name     = "${local.name_prefix}-vnet-rg"
  location = var.location

}

## Network resources
resource "azurerm_virtual_network" "main" {
  name                = "${local.name_prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.vnet.name
  address_space       = [var.aro_virtual_network_cidr_block]
  tags                = var.tags

}

resource "azurerm_subnet" "control_plane_subnet" {
  name                                           = "${local.name_prefix}-cp-subnet"
  resource_group_name                            = azurerm_resource_group.vnet.name
  virtual_network_name                           = azurerm_virtual_network.main.name
  address_prefixes                               = [var.aro_control_subnet_cidr_block]
  service_endpoints                              = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
  private_link_service_network_policies_enabled  = true
  private_endpoint_network_policies_enabled = true

}

resource "azurerm_subnet" "machine_subnet" {
  name                 = "${local.name_prefix}-machine-subnet"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aro_machine_subnet_cidr_block]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

## ARO Cluster

resource "azureopenshift_redhatopenshift_cluster" "cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  cluster_resource_group = "${local.name_prefix}-cluster-rg"

  master_profile {
    subnet_id = azurerm_subnet.control_plane_subnet.id
  }
  worker_profile {
    subnet_id = azurerm_subnet.machine_subnet.id
  }
  service_principal {
    client_id     = azuread_service_principal.cluster.application_id
    client_secret = azuread_service_principal_password.cluster.value
  }

  api_server_profile {
    visibility = var.api_server_profile
  }

  ingress_profile {
    visibility = var.ingress_profile
  }

  cluster_profile {
    pull_secret = file(var.pull_secret_path)
    version     = var.aro_version
  }

  depends_on = [
    azurerm_role_assignment.vnet
  ]
}
