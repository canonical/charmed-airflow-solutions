locals {
  cos_enabled             = var.cos_configuration
  otel_collector_app_name = "otel-collector"
}

resource "juju_application" "otel_collector_k8s" {
  count      = local.cos_enabled && var.existing_otel_collector_name == null ? 1 : 0
  name       = local.otel_collector_app_name
  model_uuid = var.model_uuid
  charm {
    name    = "opentelemetry-collector-k8s"
    channel = "0.130/stable"
  }
  trust  = true
  units  = 1
  config = {}
}

locals {
  otel_collector_resolved_name = local.cos_enabled ? (
    var.existing_otel_collector_name != null
    ? var.existing_otel_collector_name
    : juju_application.otel_collector_k8s[0].name
  ) : null
}

resource "juju_integration" "coordinator_to_otel_collector" {
  count      = local.cos_enabled ? 1 : 0
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.requires.send_otlp
  }
  application {
    name     = local.otel_collector_resolved_name
    endpoint = "receive-otlp"
  }
  depends_on = [
    module.airflow_coordinator,
    juju_application.otel_collector_k8s,
  ]
}

resource "juju_integration" "coordinator_dashboards_to_otel_collector" {
  count      = local.cos_enabled ? 1 : 0
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.provides.grafana_dashboards
  }
  application {
    name     = local.otel_collector_resolved_name
    endpoint = "grafana-dashboards-consumer"
  }
  depends_on = [
    module.airflow_coordinator,
    juju_application.otel_collector_k8s,
  ]
}
