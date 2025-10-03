terraform {
  backend "azurerm" {
    resource_group_name = "tfstate-rg"
    storage_account_name = "tfstateinbackend"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }

}

provider "azurerm" {

  features {
    
  }
  
}

resource "azurerm_resource_group" "tf-rg" {
  name     = var.resource_group
  location = var.region
}

resource "azurerm_virtual_network" "tf-vn" {
  name                = "tfrg-vn"
  location            = var.region
  resource_group_name = azurerm_resource_group.tf-rg.name
  address_space       = ["10.0.0.0/16"]

}
