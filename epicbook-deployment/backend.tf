terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateinbackend"
    container_name       = "tfstate"
    key                  = "epkbk-terraform.tfstate"
  }
}

