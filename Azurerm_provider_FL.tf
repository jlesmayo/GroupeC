terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id : "Ecole By Cap"
  subscription_id = "d3e7e11a-8150-488d-9453-f0e1ef30bb7a"
}

data "azurerm_resource_group" "GroupeN" {
  name = "Intervenants" # change by Groupe1/Groupe2/...

}






