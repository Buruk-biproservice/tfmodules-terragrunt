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
  containerapp_environment = "providermock-app-env" #evtl. falsch???
}

# Container App erzeugen für Providermock [Converter]
resource "azurerm_container_app" "providermockapp-Converter" {
  name                         = var.convname 
  container_app_environment_id = var.container_app_environment_id #muss evtl. durch variable ersetzt werden
  resource_group_name          = var.ressource_group_name
  revision_mode                = "Single"
 # Secretsbenutzen
  registry {
    server               = var.container_registry_login_server
    username             = var.container_registry_name
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
    value = "rGSAi+YRomxytwts3bP9Xn2pC0e/AG1eZZG6HY6Su0+ACRAwEqo+" #Github = var.registry_secret
  }
  tags = local.default_tags
}
