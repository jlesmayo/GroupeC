
variable "vm_name_pfx" {
  description = "VM Names"
  default     = "test-vm" #to update by Groupe#
  type        = string
}


resource "azurerm_linux_virtual_machine" "example" {
  name                            = var.vm_name_pfx
  resource_group_name             = data.azurerm_resource_group.GroupeN.name
  location                        = data.azurerm_resource_group.GroupeN.location
  size                            = "Standard_B1s" #allowed: Standard_B1ls Standard_B1ms Standard_B1s Standard_B2s Standard_D2s_v3 Standard_DS1_v2
  computer_name                   = "myvm"
  admin_username                  = "adminuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    name                 = "my-terraform-os-disk-${var.vm_name_pfx}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  tags = {
    environment = "Ecole_CAP_Azure"
    session     = "1"
    groupe      = "0"
  }
}