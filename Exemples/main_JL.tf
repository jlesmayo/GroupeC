# Create a resource group
resource "azurerm_resource_group" "RG-TEST-TF-JLES" {
  name     = "${var.prefix}-RG"
  location = var.location
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

############################################
# DEBUT CREATION D'UN BASTION
############################################

# PAS NECESSAIRE DU COUP
# Create an Azure Vnet for Bastion
#resource "azurerm_virtual_network" "VNET2-TEST-TF-JLES" {
#  name                = "${var.prefix}-VNET2"
#  address_space       = ["192.168.1.0/24"]
#  location            = var.location
#  resource_group_name = azurerm_resource_group.RG-TEST-TF-JLES.name
#  tags = {
#    environment = "TEST"
#    use_for     = "BASTION"
#  }
#}

# Create an Azure Subnet for Bastion
resource "azurerm_subnet" "SUBNET2-TEST-TF-JLES" {
  #Le name du Subnet Bastion doit être strictement égal à AzureBastionSubnet, il m'a jeté tant que c'était pas ça
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.RG-TEST-TF-JLES.name
  virtual_network_name = azurerm_virtual_network.VNET-TEST-TF-JLES.name
  address_prefixes     = ["10.0.3.224/27"]
}

# Create a public IP for Bastion
resource "azurerm_public_ip" "BASTION-IPPUB-TEST-TF-JLES" {
  name                = "${var.prefix}-BASTION-IPPUB"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-TEST-TF-JLES.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    environment = "TEST"
    use_for     = "BASTION"
  }
}

# Create a Bastion
resource "azurerm_bastion_host" "BASTION-TEST-TF-JLES" {
  name                = "${var.prefix}-BASTION"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-TEST-TF-JLES.name

  ip_configuration {
    name                 = "${var.prefix}-BASTION-CONF"
    subnet_id            = azurerm_subnet.SUBNET2-TEST-TF-JLES.id
    public_ip_address_id = azurerm_public_ip.BASTION-IPPUB-TEST-TF-JLES.id
  }
  tags = {
    environment = "TEST"
    use_for     = "BASTION"
  }
  
  #Par défault cette option est à true
  copy_paste_enabled = true

  #Option file_copy_enabled que j'ai essayé d'ajouter mais j'ai eu :
  #Error: `file_copy_enabled` is only supported when `sku` is `Standard`
  #Et flemme de changer le sku

  #file_copy_enabled  = true
}

############################################
# FIN CREATION D'UN BASTION
############################################

#Toi qui a lu en détails ces petits bouts de code, tu es super séduisant(e) <3