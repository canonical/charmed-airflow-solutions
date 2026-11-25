output "applications" {
  description = "All charm modules which make up this product module."
  value = {
    postgresql = module.postgresql
    pgbouncer  = juju_application.pgbouncer
    airflow = {
      coordinator   = module.airflow_coordinator
      api_server    = module.airflow_api_server
      scheduler     = module.airflow_scheduler
      triggerer     = module.airflow_triggerer
      dag_processor = module.airflow_dag_processor
      executor      = local.executor_module
    }
  }
}

# OpenTelemetry Collector (only if cos_configuration = true)
output "otel_collector_k8s" {
  description = "opentelemetry-collector-k8s application name when COS is enabled."
  value = var.cos_configuration ? {
    app_name = local.otel_collector_resolved_name
  } : {}
}

