# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "TEST-TF-JLES-RG"
    storage_account_name = "storagetestjles"
    container_name = "tfstate"
    key = "infra.tfstate"
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "a177ac1b-f0e1-45e5-a6c4-80266ff85e1d"
}
