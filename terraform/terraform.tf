terraform {
  required_version = ">= 1.1.0, < 1.2.0"
  #Use the latest by default, uncomment below to pin or use hcl.lck
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #      configuration_aliases = [azurerm.default-provider]
      #      version = "~> 2.68.0"
    }
  }
  backend "azurerm" {
  }
}