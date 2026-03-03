module "postgresql" {
  # rev742 is the latest charm revision for postgresql-k8s 16/edge.
  source     = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=rev742"
  juju_model = var.model_uuid
  app_name   = var.postgresql.app_name
  channel    = var.postgresql.channel
  base       = var.postgresql.base
  units      = var.postgresql.units
  storage_directives = var.postgresql.storage_directives
  config = merge(
    var.postgresql.config,
    { profile = var.postgresql.profile }
  )
}

resource "juju_application" "pgbouncer" {
  name       = var.pgbouncer.app_name
  model_uuid = var.model_uuid
  trust      = true
  units      = var.pgbouncer.units
  config     = var.pgbouncer.config
  charm {
    name     = "pgbouncer-k8s"
    channel  = var.pgbouncer.channel
    revision = var.pgbouncer.revision != null ? var.pgbouncer.revision : null
  }
}

module "airflow_coordinator" {
  source     = "git::https://github.com/canonical/airflow-coordinator-k8s-operator//terraform?ref=9a37d488d5ad1b2306f5b6ab7e62e57ae0075116"
  model_uuid = var.model_uuid
  app_name   = var.airflow_coordinator.app_name
  channel    = var.airflow_coordinator.channel
  units      = var.airflow_coordinator.units
  config     = var.airflow_coordinator.config
  revision   = var.airflow_coordinator.revision
}

module "airflow_api_server" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/api-server/terraform?ref=b88b70bec903293c62b3266ea823747ffdeebbfe"
  model_uuid = var.model_uuid
  app_name   = var.airflow_api_server.app_name
  channel    = var.airflow_api_server.channel
  units      = var.airflow_api_server.units
  config     = var.airflow_api_server.config
  revision   = var.airflow_api_server.revision

}

module "airflow_scheduler" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/scheduler/terraform?ref=b88b70bec903293c62b3266ea823747ffdeebbfe"
  model_uuid = var.model_uuid
  app_name   = var.airflow_scheduler.app_name
  channel    = var.airflow_scheduler.channel
  units      = var.airflow_scheduler.units
  config     = var.airflow_scheduler.config
  revision   = var.airflow_scheduler.revision
}

module "airflow_triggerer" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/triggerer/terraform?ref=b88b70bec903293c62b3266ea823747ffdeebbfe"
  model_uuid = var.model_uuid
  app_name   = var.airflow_triggerer.app_name
  channel    = var.airflow_triggerer.channel
  units      = var.airflow_triggerer.units
  config     = var.airflow_triggerer.config
  revision   = var.airflow_triggerer.revision
}

module "airflow_dag_processor" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/dag-processor/terraform?ref=b88b70bec903293c62b3266ea823747ffdeebbfe"
  model_uuid = var.model_uuid
  app_name   = var.airflow_dag_processor.app_name
  channel    = var.airflow_dag_processor.channel
  units      = var.airflow_dag_processor.units
  config     = var.airflow_dag_processor.config
  revision   = var.airflow_dag_processor.revision
}
