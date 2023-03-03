resource "azurerm_virtual_network" "example" {
  name                = "Intervenants-vnet" # to change by Groupe ....
  resource_group_name = data.azurerm_resource_group.GroupeN.name
  location            = data.azurerm_resource_group.GroupeN.location
  address_space       = ["10.0.0.0/16"] # to change by Groupe ....

  tags = {
    environment = "Ecole_CAP_Azure"
    session     = "1"
    groupe      = "0"
  }
}