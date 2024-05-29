variable "convname" {
  description = "Name of Converter"
}
variable "container_app_environment_id" {
  description = "environment des Infrastructure Modules"
  type = string
}
variable "container_registry_login_server" {
  description = "ContainerRegistry_login Server des Infrastructure Modules"
  type = string
}
variable "container_registry_name" {
 description = "ContainerRegistry_Name des Infrastructure Modules" 
 type = string
}
variable "ressource_group_name" {
  description = "RessourceGroup_Name des Infrastructure Modules"
  type = string  
}