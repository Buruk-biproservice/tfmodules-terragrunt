terraform {
  required_version = ">=1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.85.0"
    }
  }
  # Angaben zu den Ressourcen für GitActions
  backend "azurerm" {
    resource_group_name = "tfstateprovidermock"
    storage_account_name = "tfcodeprovidermock"
    container_name = "tfstatefile"
    key = "terraform.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

#Storage account benötigt Provider > Microsoft.Storage
resource "azurerm_resource_provider_registration" "providerMicrosoftStorage" {
  name = "Microsoft.Storage"
}

#Log Analytics Dashboard benötigt Provider > Microsoft.OperationalInsights
resource "azurerm_resource_provider_registration" "providerMicrosoftOperationalInsights" {
  name = "Microsoft.OperationalInsights"
}

# App Environment benötigt Provider > Microsoft.App
resource "azurerm_resource_provider_registration" "providerMicrosoftApp" {
  name = "Microsoft.App"
}

#Container Registry benötigt Provider > Microsoft.ContainerRegistry
resource "azurerm_resource_provider_registration" "providerMicrosoftContainerRegistry" {
  name = "Microsoft.ContainerRegistry"
}

#Key Vault benötigt Provider > Microsoft.KeyVault (wird evtl. nicht benötigt)
resource "azurerm_resource_provider_registration" "providerMicrosoftKeyVault" {
  name = "Microsoft.KeyVault"
}
