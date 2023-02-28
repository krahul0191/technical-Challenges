# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.39.0"
    }
  }
}

provider "azapi" {
}

provider "azurerm" {
  features {}
}

# module to get the instance metadata
module "vm_metadata" {
  source              = "./instance-metadata"
  resource_group_name = "poc"
  instance_name       = "vmtestdemo001"
}
