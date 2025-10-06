resource "azurerm_mysql_flexible_server" "mysqlServer" {
  name                   = "${var.prefix}-mysqldb"
  resource_group_name    = var.resource_group
  location               = var.region
  administrator_login    = var.mysqlAdmin
  administrator_password = var.mysqlAdminPass
  backup_retention_days  = 1
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  storage {
    size_gb = 20
  }

  delegated_subnet_id = var.subnet_id
  private_dns_zone_id = var.private_dns_zone_id

}

resource "azurerm_mysql_flexible_database" "mysqlDB" {
  name                = "bookstore" # pre-defined as used in project
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_flexible_server.mysqlServer.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  lifecycle {
    ignore_changes = [
      charset, collation
    ]
  }
}

# resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure" {
#   name             = "AllowAzureServices"
#   resource_group_name = var.resource_group
#   server_name      = azurerm_mysql_flexible_server.mysqlServer.name
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }
