terraform {
  backend "azurerm" {
    resource_group_name  = "rg-technologia"
    storage_account_name = "technologiastorageqqqq"
    container_name       = "technologiacontainer"
    key                  = "technologia.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = ""
}
