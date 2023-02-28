locals {
  common_tags = {
    project = var.project_label
    appname = var.appname
    env     = var.env
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}