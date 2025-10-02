terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-westeurope" {
  name     = "storage-rg-westeurope"
  location = "westeurope"
}

resource "azurerm_storage_account" "storage-westeurope" {
  name                     = "imshakilstoragewesteu"
  resource_group_name      = azurerm_resource_group.rg-westeurope.name
  location                 = azurerm_resource_group.rg-westeurope.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    region      = "westeurope"
    Environment = "Test"
  }
}
