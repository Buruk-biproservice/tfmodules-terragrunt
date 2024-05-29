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
    resource_group_name  = "tfstateprovidermock"
    storage_account_name = "tfcodeprovidermock"
    container_name       = "tfstatefile"
    key                  = "terraformDEV.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  skip_provider_registration = true
  features {}
}

module "infrastructure" {
  source =  "../../modules/infrastructure"
    region_location = "germanywestcentral"
    containerapp_environment = "providermock-app-env-dev"
  }

module "converter" {
  source   = "../../modules/converter"
  convname = "biproconverterdev"
  container_app_environment_id = module.infrastructure.container_app_environment_id
  container_registry_login_server = module.infrastructure.container_registry_login_server
  container_registry_name = module.infrastructure.container_registry_name
  ressource_group_name = module.infrastructure.ressource_group_name
}