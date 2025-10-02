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

resource "azurerm_resource_group" "rg-eastus" {
  name     = "storage-rg-eastus"
  location = "eastus"
}

resource "azurerm_storage_account" "storage-eastus" {
  name                     = "imshakilstorageeastus"
  resource_group_name      = azurerm_resource_group.rg-eastus.name
  location                 = azurerm_resource_group.rg-eastus.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    region      = "easus"
    Environment = "Test"
  }
}
