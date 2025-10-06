provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "epkbk-rg" {
  name     = "${var.prefix}-rg"
  location = var.region
}

module "network" {
  source               = "./modules/network"
  resource_group       = azurerm_resource_group.epkbk-rg.name
  region               = azurerm_resource_group.epkbk-rg.location
  vnet_cidr            = var.vnet_cidr
  prefix               = var.prefix
  public_subnet1_cidr  = var.vnet_cidr_public_sub1
  private_subnet1_cidr = var.vnet_cidr_private_sub1
}

module "db" {
  source              = "./modules/db"
  resource_group      = azurerm_resource_group.epkbk-rg.name
  region              = azurerm_resource_group.epkbk-rg.location
  subnet_id           = module.network.private_subnet1_id
  private_dns_zone_id = module.network.private_dns_zone_id
  dns_zone_link_id    = module.network.private_dns_zone_link_id
  prefix              = var.prefix
  mysqlAdmin          = var.mysqlAdmin
  mysqlAdminPass      = var.mysqlAdminPass

}

module "vm" {
  source         = "./modules/vm"
  resource_group = azurerm_resource_group.epkbk-rg.name
  region         = azurerm_resource_group.epkbk-rg.location
  subnet_id      = module.network.public_subnet1_id
  prefix         = var.prefix
  ssh_username   = var.ssh_username
  ssh_key_path   = var.ssh_key_path
  db_hostname    = module.db.db_hostname
  mysqlAdmin     = var.mysqlAdmin
  mysqlAdminPass = var.mysqlAdminPass

}
