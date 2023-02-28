
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

resource "azurerm_public_ip" "azurerm_public_ip" {
  name                = "${var.project_label}-${var.appname}-pip-${var.env}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  allocation_method   = "Static"
  domain_name_label   = "${var.project_label}-${var.appname}-public-ip-${var.env}"
}


resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                   = "${var.project_label}-${var.appname}-tm-${var.env}"
  resource_group_name    = data.azurerm_resource_group.resource_group.name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = "${var.project_label}-${var.appname}-profile-${var.env}"
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

  tags = local.common_tags
}

resource "azurerm_traffic_manager_azure_endpoint" "tm_endpoint" {
  name               = "${var.project_label}-${var.appname}-tmedpoint-${var.env}"
  profile_id         = azurerm_traffic_manager_profile.traffic_manager.id
  weight             = 100
  target_resource_id = azurerm_public_ip.azurerm_public_ip.id
}