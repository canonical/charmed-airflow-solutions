resource "null_resource" "wait_for_postgresql" {
  depends_on = [module.postgresql]

  provisioner "local-exec" {
    command = "juju wait-for model $(juju show-model ${var.model_uuid} --format=json | jq -r '.[keys[0]].name') --timeout=20m --query=\"apps['${var.postgresql.app_name}'].status == 'active'\""
  }
}

resource "juju_integration" "coordinator_to_postgresql" {
  depends_on = [null_resource.wait_for_postgresql]
  model_uuid = var.model_uuid
  application {
    name     = var.airflow_coordinator.app_name
    endpoint = module.airflow_coordinator.requires.postgres
  }
  application {
    name     = var.postgresql.app_name
    endpoint = module.postgresql.provides.database
  }
}

resource "juju_integration" "api_server_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = var.airflow_api_server.app_name
    endpoint = module.airflow_api_server.requires.airflow_coordinator
  }
  application {
    name     = var.airflow_coordinator.app_name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}

resource "juju_integration" "scheduler_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = var.airflow_scheduler.app_name
    endpoint = module.airflow_scheduler.requires.airflow_coordinator
  }
  application {
    name     = var.airflow_coordinator.app_name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}

resource "juju_integration" "triggerer_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = var.airflow_triggerer.app_name
    endpoint = module.airflow_triggerer.requires.airflow_coordinator
  }
  application {
    name     = var.airflow_coordinator.app_name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}

resource "juju_integration" "dag_processor_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = var.airflow_dag_processor.app_name
    endpoint = module.airflow_dag_processor.requires.airflow_coordinator
  }
  application {
    name     = var.airflow_coordinator.app_name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}
