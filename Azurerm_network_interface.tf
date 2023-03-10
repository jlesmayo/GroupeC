resource "azurerm_network_interface" "example" {
  name                = "${var.vm_name_pfx}-nic"
  location            = data.azurerm_resource_group.rg_51_groupec.location
  resource_group_name = data.azurerm_resource_group.rg_51_groupec.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "Ecole_CAP_Azure-GC"
    session     = "1"
    groupe      = "0"
  }
}
