resource "azurerm_mysql_server" "demo" {
  name                = "mysql-training"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = "mysqladmin"
  administrator_login_password = "r0b3rt1t0RBM2018"
  version                      = "5.7"
  ssl_enforcement_enabled      = true
}

resource "azurerm_mysql_database" "training" {
  name                = "demodb"
  resource_group_name = azurerm_resource_group.demo.name
  server_name         = azurerm_mysql_server.demo.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_virtual_network_rule" "demo-database-subnet-vnet-rule" {
  name                = "mysql-vnet-rule"
  resource_group_name = azurerm_resource_group.demo.name
  server_name         = azurerm_mysql_server.demo.name
  subnet_id           = azurerm_subnet.demo-database-1.id
}

resource "azurerm_mysql_virtual_network_rule" "demo-subnet-vnet-rule" {
  name                = "mysql-demo-subnet-vnet-rule"
  resource_group_name = azurerm_resource_group.demo.name
  server_name         = azurerm_mysql_server.demo.name
  subnet_id           = azurerm_subnet.demo-internal-1.id
}

resource "azurerm_mysql_firewall_rule" "demo-allow-demo-instance" {
  name                = "mysql-demo-instance"
  resource_group_name = azurerm_resource_group.demo.name
  server_name         = azurerm_mysql_server.demo.name
  start_ip_address    = azurerm_network_interface.demo-instance.private_ip_address
  end_ip_address      = azurerm_network_interface.demo-instance.private_ip_address
}
