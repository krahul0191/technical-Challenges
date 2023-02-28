output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = [for n in azurerm_subnet.subnet_app : n.id]
}