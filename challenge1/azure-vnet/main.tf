# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

locals {
  common_tags = {
    project = var.project_label
    appname = var.appname
    env     = var.env
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_label}-${var.appname}-${var.env}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  address_space       = var.address_space_vnet
  tags                = local.common_tags
}

resource "azurerm_subnet" "subnet_app" {
  for_each             = var.subnets
  name                 = each.value.subnet_name
  address_prefixes     = each.value.subnet_address_prefix
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    content {
      name = lookup(each.value.delegation, "name", null)
      service_delegation {
        name    = lookup(each.value.delegation.service_delegation, "name", null)
        actions = lookup(each.value.delegation.service_delegation, "actions", null)
      }
    }
  }

}