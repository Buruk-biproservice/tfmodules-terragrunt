locals {
  default_tags = {
    environment = "dev"
    owner       = "kamil.buruk@bipro-service.gmbh"
    created_by  = "terraform"
  }
}

resource "azurerm_resource_group" "providermock" {
  name     = "providermock"
  location = "germanywestcentral"

  tags = local.default_tags
}

resource "azurerm_storage_account" "providermock" {
  name                     = "biproprovidermockstorage"
  resource_group_name      = azurerm_resource_group.providermock.name
  location                 = azurerm_resource_group.providermock.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.default_tags
}

resource "azurerm_log_analytics_workspace" "providermock-la-ws" {
  name                = "providermock-la-ws"
  location            = azurerm_resource_group.providermock.location
  resource_group_name = azurerm_resource_group.providermock.name
  sku                 = "PerGB2018"

  tags = local.default_tags
}

resource "azurerm_container_registry" "acr" {
  name                   = "containerRegistryBipro"
  resource_group_name    = azurerm_resource_group.providermock.name
  location               = azurerm_resource_group.providermock.location
  sku                    = "Standard" # change to Premium for georeplication
  admin_enabled          = true
  anonymous_pull_enabled = false #kritisch falls true!!!!!!!!!!!!!
}

resource "azurerm_role_assignment" "acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "Contributor"
  principal_id         = "5056f103-616c-4b26-91c4-6cecb18a0002"
}

resource "azurerm_container_app_environment" "providermock-app-env" {
  name                       = "providermock-app-env"
  location                   = azurerm_resource_group.providermock.location
  resource_group_name        = azurerm_resource_group.providermock.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.providermock-la-ws.id

  tags = local.default_tags
}
