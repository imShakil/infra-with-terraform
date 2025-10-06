output "db_server_name" {
  value = azurerm_mysql_flexible_server.mysqlServer.name
}

output "db_name" {
  value = azurerm_mysql_flexible_database.mysqlDB.name
}

output "db_hostname" {
  value = azurerm_mysql_flexible_server.mysqlServer.fqdn
}
