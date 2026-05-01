module "charmed_airflow" {
  source = "../charmed-airflow"

  model_uuid                  = var.model_uuid
  airflow_api_server          = var.airflow_api_server
  airflow_coordinator         = var.airflow_coordinator
  airflow_dag_processor       = var.airflow_dag_processor
  airflow_scheduler           = var.airflow_scheduler
  airflow_triggerer           = var.airflow_triggerer
  executor                    = var.executor
  airflow_kubernetes_executor = var.airflow_kubernetes_executor
  postgresql                  = var.postgresql
  pgbouncer                   = var.pgbouncer
}

module "traefik" {
  source     = "git::https://github.com/canonical/traefik-k8s-operator//terraform?ref=rev292"
  model_uuid = var.model_uuid
  app_name   = var.traefik.app_name
  channel    = var.traefik.channel
  units      = var.traefik.units
  config     = var.traefik.config
  revision   = var.traefik.revision
}

module "git_integrator" {
  source     = "git::https://github.com/canonical/git-integrator//terraform?ref=git-integrator-rev4"
  model_uuid = var.model_uuid
  app_name   = var.git_integrator.app_name
  channel    = var.git_integrator.channel
  units      = var.git_integrator.units
  config     = var.git_integrator.config
  revision   = var.git_integrator.revision
}
