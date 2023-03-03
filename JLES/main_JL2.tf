# Create a resource group
resource "azurerm_resource_group" "RG-TEST-TF-JLES" {
  name     = "${var.prefix}-RG"
  location = var.location
  tags = {
    environment = "TEST"
  }
}

resource "azurerm_storage_account" "SA-TEST-TF-JLES" {
  name                     = "storagetestjles"
  resource_group_name      = azurerm_resource_group.RG-TEST-TF-JLES.name
  #azurerm_resource_group.RG-TEST-TF-JLES.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "TEST"
  }
}

############################################
# DEBUT CREATION D'UNE VM
############################################

# Create an Azure VNET
resource "azurerm_virtual_network" "VNET-TEST-TF-JLES" {
  name                = "${var.prefix}-VNET"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-TEST-TF-JLES.name
  tags = {
    environment = "TEST"
    use_for     = "VM"
  }
}

# Create an Azure Subnet for VM
resource "azurerm_subnet" "SUBNET-TEST-TF-JLES" {
  name                 = "${var.prefix}-SUBNET"
  resource_group_name  = azurerm_resource_group.RG-TEST-TF-JLES.name
  virtual_network_name = azurerm_virtual_network.VNET-TEST-TF-JLES.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create an Azure NIC for VM
resource "azurerm_network_interface" "NIC-TEST-TF-JLES" {
  name                = "${var.prefix}-NIC"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-TEST-TF-JLES.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SUBNET-TEST-TF-JLES.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = "TEST"
    use_for     = "VM"
  }
}

# Create an Azure VM
resource "azurerm_linux_virtual_machine" "LINUX-VM-TEST-TF-JLES" {
  name                = "${var.prefix}-LINUX-VM"
  resource_group_name = azurerm_resource_group.RG-TEST-TF-JLES.name
  location            = var.location
  size                = "Standard_DS1_v2"
  computer_name       = "${var.prefix}-VM-HOSTNAME"
  admin_username      = "adminuser"
  #Ce qu'il y a en dessous c'est pas bien !!!
  admin_password      = "Bisounours4life!"
  #Ce qu'il y a au dessus c'est pas bien !!!

  network_interface_ids = [
    azurerm_network_interface.NIC-TEST-TF-JLES.id,
  ]
  #Option que j'ai ajouté car il ne voulait pas prendre le pavé en dessous de cette option
  disable_password_authentication = false
  
#  admin_ssh_key {
#    username   = "adminuser"
#    public_key = file("~/.ssh/id_rsa.pub")
#  }

  os_disk {
    name                 = "${var.prefix}-OS-DISK"
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
    environment = "TEST"
    use_for     = "VM"
  }
}

############################################
# FIN CREATION D'UNE VM
############################################
