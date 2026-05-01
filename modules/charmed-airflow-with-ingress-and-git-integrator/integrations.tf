resource "juju_integration" "traefik_to_api_server" {
  model_uuid = var.model_uuid
  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints["ingress"]
  }
  application {
    name     = module.charmed_airflow.applications.airflow.api_server.application.name
    endpoint = "ingress"
  }
}

resource "juju_integration" "git_integrator_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = module.git_integrator.application.name
    endpoint = module.git_integrator.provides.git
  }
  application {
    name     = module.charmed_airflow.applications.airflow.coordinator.application.name
    endpoint = "git"
  }
}
