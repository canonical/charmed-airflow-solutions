module "postgresql" {
  # rev742 is the latest charm revision for postgresql-k8s 16/edge.
  source             = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=rev742"
  juju_model         = var.model_uuid
  app_name           = var.postgresql.app_name
  channel            = var.postgresql.channel
  base               = var.postgresql.base
  revision           = var.postgresql.revision
  units              = var.postgresql.units
  constraints        = var.postgresql.constraints
  storage_directives = var.postgresql.storage_directives
  resources          = var.postgresql.resources
  config             = var.postgresql.config
}

module "airflow_coordinator" {
  source      = "git::https://github.com/canonical/airflow-coordinator-k8s-operator//terraform?ref=track/3.1"
  model_uuid  = var.model_uuid
  app_name    = var.airflow_coordinator.app_name
  channel     = var.airflow_coordinator.channel
  revision    = var.airflow_coordinator.revision
  units       = var.airflow_coordinator.units
  constraints = var.airflow_coordinator.constraints
  config      = var.airflow_coordinator.config
}

module "airflow_api_server" {
  source      = "git::https://github.com/canonical/airflow-core-operators//charms/api-server/terraform?ref=track/3.1"
  model_uuid  = var.model_uuid
  app_name    = var.airflow_api_server.app_name
  channel     = var.airflow_api_server.channel
  revision    = var.airflow_api_server.revision
  units       = var.airflow_api_server.units
  constraints = var.airflow_api_server.constraints
  config      = var.airflow_api_server.config
}

module "airflow_scheduler" {
  source      = "git::https://github.com/canonical/airflow-core-operators//charms/scheduler/terraform?ref=track/3.1"
  model_uuid  = var.model_uuid
  app_name    = var.airflow_scheduler.app_name
  channel     = var.airflow_scheduler.channel
  revision    = var.airflow_scheduler.revision
  units       = var.airflow_scheduler.units
  constraints = var.airflow_scheduler.constraints
  config      = var.airflow_scheduler.config
}

module "airflow_triggerer" {
  source      = "git::https://github.com/canonical/airflow-core-operators//charms/triggerer/terraform?ref=track/3.1"
  model_uuid  = var.model_uuid
  app_name    = var.airflow_triggerer.app_name
  channel     = var.airflow_triggerer.channel
  revision    = var.airflow_triggerer.revision
  units       = var.airflow_triggerer.units
  constraints = var.airflow_triggerer.constraints
  config      = var.airflow_triggerer.config
}

module "airflow_dag_processor" {
  source      = "git::https://github.com/canonical/airflow-core-operators//charms/dag-processor/terraform?ref=track/3.1"
  model_uuid  = var.model_uuid
  app_name    = var.airflow_dag_processor.app_name
  channel     = var.airflow_dag_processor.channel
  revision    = var.airflow_dag_processor.revision
  units       = var.airflow_dag_processor.units
  constraints = var.airflow_dag_processor.constraints
  config      = var.airflow_dag_processor.config
}
