resource "azurerm_container_app" "providermockapp-wiremock" {
  name                         = "biprowiremock"
  container_app_environment_id = azurerm_container_app_environment.providermock-app-env.id
  resource_group_name          = azurerm_resource_group.providermock.name
  revision_mode                = "Single"

  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.name
    password_secret_name = "containerregistrybiproazurecriopass"
  
  }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 8090
    traffic_weight {
      latest_revision          = true
      percentage               = 100
    }
  }

  template {
    container {
      name   = "biprowiremock"
      image  = "containerregistrybipro.azurecr.io/bipro/wiremocktest:latest"
      cpu    = 1.0
      memory = "2Gi"
    }
    min_replicas = 1
    max_replicas = 1
  }

  secret { 
    name  = "containerregistrybiproazurecriopass"
    value = var.registry_secret
  }

  tags = local.default_tags

}
