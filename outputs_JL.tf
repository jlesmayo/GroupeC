output "vm_name" {
  description = "Virtual machine name created."
  value = {
    linux   = azurerm_linux_virtual_machine.LINUX-VM-TEST-TF-JLES.name
  }
}

output "bastion_name" {
  description = "Bastion name created."
  value = azurerm_bastion_host.BASTION-TEST-TF-JLES.name
}