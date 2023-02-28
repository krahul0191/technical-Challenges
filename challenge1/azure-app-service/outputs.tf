output "asp_ids" {
  value = azurerm_service_plan.service_plan.id
}

output "app_linux_ids" {
  value = [for n in azurerm_linux_web_app.linux_webapp : n.id]
}

output "app_windows_ids" {
  value = [for n in azurerm_windows_web_app.windows_webapp : n.id]
}

