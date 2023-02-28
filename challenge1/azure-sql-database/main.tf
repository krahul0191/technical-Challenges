# Getting existing resource group properties
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}
# defining tags
locals {
  common_tags = {
    project = var.project_label
    appname = var.appname
    env     = var.env
  }
}
# block for the sql server main
resource "azurerm_mssql_server" "sql_server_main" {
  name                          = "${var.project_label}-${var.appname}-server-main-${var.env}"
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  location                      = data.azurerm_resource_group.resource_group.location
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = var.tls_version
  public_network_access_enabled = false
  tags                          = local.common_tags

  azuread_administrator {
    login_username = var.azuread_name
    object_id      = var.ad_object_id
  }

}

# block for the sql server backup
resource "azurerm_mssql_server" "sql_server_second" {
  name                          = "${var.project_label}-${var.appname}-server-second-${var.env}"
  resource_group_name           = data.azurerm_resource_group.resource_group.name
  location                      = "west us"
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  minimum_tls_version           = var.tls_version
  public_network_access_enabled = false
  tags                          = local.common_tags

  azuread_administrator {
    login_username = var.azuread_name
    object_id      = var.ad_object_id
  }

}
# Block for the storage account
resource "azurerm_storage_account" "storage" {
  name                     = "${var.project_label}${var.appname}storage${var.env}"
  resource_group_name      = data.azurerm_resource_group.resource_group.name
  location                 = data.azurerm_resource_group.resource_group.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  tags                     = local.common_tags
}
# block for the sql database
resource "azurerm_mssql_database" "sqldb" {
  name           = "${var.project_label}-${var.appname}-database-${var.env}"
  server_id      = azurerm_mssql_server.sql_server_main.id
  collation      = var.collation
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = var.sku
  zone_redundant = false
  tags           = local.common_tags
}

# block for the sql failover
resource "azurerm_mssql_failover_group" "sql_failover" {
  name      = "${var.project_label}-${var.appname}-failover-${var.env}"
  server_id = azurerm_mssql_server.sql_server_main.id
  databases = [
    azurerm_mssql_database.sqldb.id
  ]

  partner_server {
    id = azurerm_mssql_server.sql_server_second.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
  tags = local.common_tags
}

# Getting existing network properties
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Getting subnet properties for the private endpoint creation.
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# Block for the private endpoint main
resource "azurerm_private_endpoint" "pvt_endpoint_main" {
  name                = "${var.project_label}-${var.appname}-pvt-endpoint-main-${var.env}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = data.azurerm_subnet.subnet.id
  tags                = local.common_tags

  private_service_connection {
    name                           = "${var.project_label}-${var.appname}-privatelink-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql_server_main.id
    subresource_names              = ["sqlServer"]
  }
}

# Block for the private endpoint backup
resource "azurerm_private_endpoint" "pvt_endpoint_second" {
  name                = "${var.project_label}-${var.appname}-pvt-endpoint-second-${var.env}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  subnet_id           = data.azurerm_subnet.subnet.id
  tags                = local.common_tags

  private_service_connection {
    name                           = "${var.project_label}-${var.appname}-privatelink-${var.env}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql_server_second.id
    subresource_names              = ["sqlServer"]
  }
}

# Block for the priate DNS zone
resource "azurerm_private_dns_zone" "dnszone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  tags                = local.common_tags
}
# Block to link the dnszone with existing network
resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  name                  = "${var.project_label}-${var.appname}-pvt-zone-link-${var.env}"
  resource_group_name   = data.azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.dnszone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  registration_enabled  = false
  tags                  = local.common_tags
}
