locals {
  default_tags = {
    environment = "dev"
    owner       = "kamil.buruk@bipro-service.gmbh"
    created_by  = "terraform"
  }
}
module "infrastructure" {
  source = "../infrastructure"
  region_location = "germanywestcentral"
}
# Container App erzeugen für Providermock [Converter]
resource "azurerm_container_app" "providermockapp-Converter" {
  name                         = var.convname # evtl. Variable daraus machen
  container_app_environment_id = module.infrastructure.azurerm_container_app_environment.providermock-app-env.id
  resource_group_name          = module.infrastructure.azurerm_resource_group.providermock.name
  revision_mode                = "Single"
 # Secretsbenutzen
  registry {
    server               = module.infrastructure.azurerm_container_registry.acr.login_server
    username             = module.infrastructure.azurerm_container_registry.acr.name
    password_secret_name = "containerregistrybiproazurecriopass"
  }
  ingress {
    allow_insecure_connections = true
    external_enabled           = false
    target_port                = 8080
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  template {
    container {
      name   = "biproconnect-430-converter"
      image  = "containerregistrybipro.azurecr.io/biproconnect-430-converter:1.9.51-26a87b8"
      cpu    = "1.0"
      memory = "2Gi"
    }
    min_replicas = 1
    max_replicas = 1
  }
  secret {# TO DO Secrets benutzen
    name  = "containerregistrybiproazurecriopass"
    value = var.registry_secret
  }
  tags = local.default_tags
}
