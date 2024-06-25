output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "linux_virtual_machine_names" {
  value = [for s in azurerm_linux_virtual_machine.vm : s.name[*]]
}

output "public_ip_address" {
  value = "${azurerm_public_ip.public_ip.*.ip_address}"
}