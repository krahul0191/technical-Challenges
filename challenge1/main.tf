# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.39.0"
    }
  }
}
provider "azurerm" {
  features {}
}



module "resource_group" {
  source              = "./azure-resource-group"
  resource_group_name = "poc"
  project_label       = "kp"
  appname             = "rg"
  env                 = "dev"
  location            = "east us"

}

module "vnet" {
  source              = "./azure-vnet"
  resource_group_name = "poc"
  project_label       = "kp"
  appname             = "vnet"
  env                 = "dev"
  address_space_vnet  = ["10.0.0.0/16"]
  subnets = {
    app_subnet = {
      subnet_name           = "subnet1"
      subnet_address_prefix = ["10.0.0.0/24"]

      delegation = {
        name = "vnetdelegetion"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    },
    db_subnet = {
      subnet_name           = "subnet2"
      subnet_address_prefix = ["10.0.1.0/24"]
    },

    app_subnet_frontend = {
      subnet_name           = "subnet3"
      subnet_address_prefix = ["10.0.2.0/24"]

      delegation = {
        name = "vnetdelegetion"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
        }
      }
    },

  }
  # depends_on = [
  #   module.resource_group
  # ]
}

module "database" {
  source                       = "./azure-sql-database"
  resource_group_name          = "poc"
  administrator_login          = "sqladmin"
  administrator_login_password = "Rahul@1234567"
  server_version               = "12.0"
  tls_version                  = "1.2"
  vnet_name                    = "kp-vnet-dev"
  subnet_name                  = "subnet2"
  sku                          = "S0"
  collation                    = "SQL_Latin1_General_CP1_CI_AS"
  replication_type             = "LRS"
  account_tier                 = "Standard"
  azuread_name                 = "rahul_terraform"
  ad_object_id                 = "6e577233-xxxx-43fa-ad1b-xxxxxxx"
  project_label                = "kp"
  appname                      = "sql"
  env                          = "dev"
  # depends_on = [
  #   module.vnet
  # ]

}

module "backend_app" {
  source              = "./azure-app-service"
  resource_group_name = "poc"
  project_label       = "kp"
  appname             = "backend"
  env                 = "dev"
  os_type             = "Windows"
  sku_name            = "S1"
  app_settings = {
    keytest1 = "value1"
    keytest2 = "value2"
  }
  site_config = {
    always_on           = true
    minimum_tls_version = "1.2"
  }
  application_stack = {
    current_stack       = "dotnetcore"
    dotnet_core_version = "v4.0"
  }
  vnet_name          = "kp-vnet-dev"
  subnet_pvtendpoint = "subnet2"
  app_subnet         = "subnet3"
  # depends_on = [
  #   module.database
  # ]
}

module "frontend_webapp" {
  source              = "./azure-app-service"
  resource_group_name = "poc"
  project_label       = "kp"
  appname             = "frontend"
  env                 = "dev"
  os_type             = "Windows"
  sku_name            = "S1"
  app_settings = {
    keytest1 = "value1"
    keytest2 = "value2"
  }
  site_config = {
    always_on           = true
    minimum_tls_version = "1.2"
  }
  application_stack = {
    current_stack = "node"
    node_version  = "~16"
  }

  vnet_name          = "kp-vnet-dev"
  subnet_pvtendpoint = "subnet2"
  app_subnet         = "subnet1"
  # depends_on = [
  #   module.database
  # ]
}


module "traffic-manager" {
  source              = "./azure-traffic-manager"
  resource_group_name = "poc"
  project_label       = "kp"
  appname             = "lb"
  env                 = "dev"
  # depends_on = [
  #   module.frontend_webapp
  # ]
}






