output "container_app_environment_id" {
  value = azurerm_container_app_environment.providermock-app-env.id
}
output "container_registry_login_server" {
  value = azurerm_container_registry.acr.login_server
}
output "container_registry_name" {
  value = azurerm_container_registry.acr.name
}
output "ressource_group_name" {
  value = azurerm_resource_group.providermock.name
}