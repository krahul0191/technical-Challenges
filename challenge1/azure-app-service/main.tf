# Azure Provider source and version being used
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

# Block for the tags
locals {
  common_tags = {
    project = var.project_label
    appname = var.appname
    env     = var.env
  }
  app_type_linux   = var.os_type == "Linux" ? true : false
  app_type_windows = var.os_type == "Windows" ? true : false
  asp_location     = var.os_type == "Linux" ? "west us" : "east us"
}

# Block for the service plan
resource "azurerm_service_plan" "service_plan" {
  name                = "${var.project_label}-${var.appname}-${var.os_type}-${var.env}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = local.asp_location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = local.common_tags
}

# Getting existing network properties
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Getting subnet properties for the private endpoint creation.
data "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "subnet_pvtendpoint" {
  name                 = var.subnet_pvtendpoint
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# block for the app service
resource "azurerm_linux_web_app" "linux_webapp" {
  count                     = local.app_type_linux ? 1 : 0
  name                      = "${var.project_label}-${var.appname}-${var.os_type}-${var.env}"
  resource_group_name       = data.azurerm_resource_group.resource_group.name
  location                  = local.asp_location
  service_plan_id           = azurerm_service_plan.service_plan.id
  tags                      = local.common_tags
  app_settings              = var.app_settings
  virtual_network_subnet_id = data.azurerm_subnet.app_subnet.id

  dynamic "site_config" {
    for_each = [var.site_config]
    content {
      always_on           = lookup(site_config.value, "always_on", false)
      minimum_tls_version = lookup(site_config.value, "minimum_tls_version", false)

      dynamic "application_stack" {
        for_each = [var.application_stack]
        content {
          python_version = lookup(application_stack.value, "python_version", "3.10")
          node_version   = lookup(application_stack.value, "node_version", null)
          dotnet_version = lookup(application_stack.value, "dotnet_core_version", null)
          java_version   = lookup(application_stack.value, "java_version", null)
          ruby_version   = lookup(application_stack.value, "ruby_version", null)
          php_version    = lookup(application_stack.value, "php_version", null)
          go_version     = lookup(application_stack.value, "go_version", null)

        }

      }
    }
  }

}

resource "azurerm_windows_web_app" "windows_webapp" {
  count                     = local.app_type_windows ? 1 : 0
  name                      = "${var.project_label}-${var.appname}-${var.os_type}-${var.env}"
  resource_group_name       = data.azurerm_resource_group.resource_group.name
  location                  = local.asp_location
  service_plan_id           = azurerm_service_plan.service_plan.id
  tags                      = local.common_tags
  app_settings              = var.app_settings
  virtual_network_subnet_id = data.azurerm_subnet.app_subnet.id

  dynamic "site_config" {
    for_each = [var.site_config]
    content {
      always_on           = lookup(site_config.value, "always_on", false)
      minimum_tls_version = lookup(site_config.value, "minimum_tls_version", false)

      dynamic "application_stack" {
        for_each = [var.application_stack]
        content {
          current_stack       = lookup(application_stack.value, "current_stack", "dotnet")
          node_version        = lookup(application_stack.value, "node_version", "~14")
          dotnet_version      = lookup(application_stack.value, "dotnet_version", "v7.0")
          dotnet_core_version = lookup(application_stack.value, "dotnet_core_version", "v4.0")
        }

      }
    }
  }

}

resource "azurerm_private_endpoint" "pvt_endpoint_linux" {
  count               = local.app_type_linux ? 1 : 0
  name                = "${var.project_label}-${var.appname}-pvt-endpointlx-${var.env}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = data.azurerm_subnet.subnet_pvtendpoint.id
  tags                = local.common_tags

  private_service_connection {
    name                           = "${var.project_label}-${var.appname}-privatelinklx-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_linux_web_app.linux_webapp[count.index].id
    subresource_names              = ["sites"]
  }
}

resource "azurerm_private_endpoint" "pvt_endpoint_win" {
  count               = local.app_type_windows ? 1 : 0
  name                = "${var.project_label}-${var.appname}-pvt-endpointwin-${var.env}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = data.azurerm_subnet.subnet_pvtendpoint.id
  tags                = local.common_tags

  private_service_connection {
    name                           = "${var.project_label}-${var.appname}-privatelinkwin-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_windows_web_app.windows_webapp[count.index].id
    subresource_names              = ["sites"]
  }
}

# Block for the private DNS zone
resource "azurerm_private_dns_zone" "dnszoneapp" {
  count               = local.app_type_windows ? 1 : 0
  name                = "${var.project_label}-${var.appname}-${var.env}.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = local.common_tags
}
# Block to link the dnszone with existing network
resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  count                 = local.app_type_windows ? 1 : 0
  name                  = "${var.project_label}-${var.appname}-pvt-zone-link-${var.env}"
  resource_group_name   = data.azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.dnszoneapp[count.index].name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.common_tags
}

# Block for the private DNS zone
resource "azurerm_private_dns_zone" "dnszoneapplx" {
  count               = local.app_type_linux ? 1 : 0
  name                = "${var.project_label}-${var.appname}-${var.env}-lx.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = local.common_tags
}
# Block to link the dnszone with existing network
resource "azurerm_private_dns_zone_virtual_network_link" "vnet-linklx" {
  count                 = local.app_type_linux ? 1 : 0
  name                  = "${var.project_label}-${var.appname}-pvt-zone-link-${var.env}"
  resource_group_name   = data.azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.dnszoneapplx[count.index].name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.common_tags
}