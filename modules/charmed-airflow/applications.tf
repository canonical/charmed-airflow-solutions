module "postgresql" {
  # tflint-ignore: terraform_module_pinned_source 16/edge.
  # rev742 is the latest charm revision for postgresql-k8s 16/edge.
  source     = "git::https://github.com/canonical/postgresql-k8s-operator//terraform?ref=rev742"
  juju_model = var.model_uuid
  app_name   = var.postgresql.app_name
  channel    = var.postgresql.channel
  base       = var.postgresql.base
  units      = var.postgresql.units
  config     = var.postgresql.config
}

module "airflow_coordinator" {
  source     = "git::https://github.com/canonical/airflow-coordinator-k8s-operator//terraform?ref=track/3.1"
  model_uuid = var.model_uuid
  app_name   = var.airflow_coordinator.app_name
  channel    = var.airflow_coordinator.channel
  units      = var.airflow_coordinator.units
  config     = var.airflow_coordinator.config
}

module "airflow_api_server" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/api-server/terraform?ref=track/3.1"
  model_uuid = var.model_uuid
  app_name   = var.airflow_api_server.app_name
  channel    = var.airflow_api_server.channel
  units      = var.airflow_api_server.units
  config     = var.airflow_api_server.config
}

module "airflow_scheduler" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/scheduler/terraform?ref=track/3.1"
  model_uuid = var.model_uuid
  app_name   = var.airflow_scheduler.app_name
  channel    = var.airflow_scheduler.channel
  units      = var.airflow_scheduler.units
  config     = var.airflow_scheduler.config
}

module "airflow_triggerer" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/triggerer/terraform?ref=track/3.1"
  model_uuid = var.model_uuid
  app_name   = var.airflow_triggerer.app_name
  channel    = var.airflow_triggerer.channel
  units      = var.airflow_triggerer.units
  config     = var.airflow_triggerer.config
}

module "airflow_dag_processor" {
  source     = "git::https://github.com/canonical/airflow-core-operators//charms/dag-processor/terraform?ref=track/3.1"
  model_uuid = var.model_uuid
  app_name   = var.airflow_dag_processor.app_name
  channel    = var.airflow_dag_processor.channel
  units      = var.airflow_dag_processor.units
  config     = var.airflow_dag_processor.config
}
