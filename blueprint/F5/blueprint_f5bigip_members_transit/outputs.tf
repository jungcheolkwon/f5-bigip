output "azurerm_public_ip_address" {
  description = "public IP address"
  value       = "${azurerm_public_ip.F5m.*.ip_address}"
}

output "network_interface_private_ip" {
  description = "private ip addresses of the vm"
  value       = "${azurerm_network_interface.F5m.*.private_ip_address}"
}
