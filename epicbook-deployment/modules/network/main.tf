resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vn"
  location            = var.region
  resource_group_name = var.resource_group
  address_space       = [var.vnet_cidr]
}

resource "azurerm_network_security_group" "public_nsg" {
  name                = "${var.prefix}-public-subnet-nsg"
  location            = var.region
  resource_group_name = var.resource_group

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "public_subnet1" {
  name                 = "${var.prefix}-vnet-public-subnet1"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.public_subnet1_cidr]

}


resource "azurerm_subnet" "private_subnet1" {
    name                 = "${var.prefix}-vnet-private-subnet1"
    resource_group_name  = var.resource_group
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = [var.private_subnet1_cidr]
    service_endpoints = ["Microsoft.Storage"]
    delegation {
      name = "fs"
      service_delegation {
        name = "Microsoft.DBforMySQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
    private_endpoint_network_policies = "Enabled"
}

resource "azurerm_network_security_group" "private_nsg" {
  name                = "${var.prefix}-vnet-private-nsg"
  location            = var.region
  resource_group_name = var.resource_group

  security_rule {
    name                       = "AllowPublicSubnet"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.public_subnet1_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id                 = azurerm_subnet.public_subnet1.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  subnet_id                 = azurerm_subnet.private_subnet1.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_private_dns_zone" "epkbk_mysqldb" {
  name = "${var.prefix}db.mysql.database.azure.com"
  resource_group_name = var.resource_group
}

resource "azurerm_private_dns_zone_virtual_network_link" "epkbk_mysqldb_dns_link" {
  name = "${var.prefix}db-link"
  resource_group_name = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.epkbk_mysqldb.name
  virtual_network_id = azurerm_virtual_network.vnet.id
  registration_enabled = false
}
