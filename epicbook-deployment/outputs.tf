output "resource_group_name" {
  value = azurerm_resource_group.epkbk-rg.name
}

output "vm_public_ip" {
  value       = module.vm.vm_public_ip
  description = "Public IP address of the VM"
}

output "db_hostname" {
  value = module.db.db_hostname
}

output "vnet-private_subnet1_id" {
  value = module.network.private_subnet1_id
}

output "vnet-public_subnet1_id" {
  value = module.network.public_subnet1_id
}

