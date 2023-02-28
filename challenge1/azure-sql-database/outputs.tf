output "sql_server_main_id" {
  value = azurerm_mssql_server.sql_server_main.id
}

output "sql_server_backup_id" {
  value = azurerm_mssql_server.sql_server_second.id
}

output "sql_db_id" {
  value = azurerm_mssql_database.sqldb.id
}

