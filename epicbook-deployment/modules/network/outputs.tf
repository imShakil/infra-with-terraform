output "vn_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vn_id" {
  value = azurerm_virtual_network.vnet.id
}

output "public_subnet1_id" {
  value = azurerm_subnet.public_subnet1.id
}

output "private_subnet1_id" {
  value = azurerm_subnet.private_subnet1.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.epkbk_mysqldb.id
}

output "private_dns_zone_link_id" {
  value = azurerm_private_dns_zone_virtual_network_link.epkbk_mysqldb_dns_link.id
}
