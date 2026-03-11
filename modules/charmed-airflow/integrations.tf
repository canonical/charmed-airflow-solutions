resource "juju_integration" "postgresql_pgbouncer" {
  model_uuid = var.model_uuid

  application {
    name     = module.postgresql.application_name
    endpoint = module.postgresql.provides.database
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "backend-database"
  }
}

resource "juju_integration" "coordinator_to_pgbouncer" {
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.requires.postgres
  }
  application {
    name     = juju_application.pgbouncer.name
    endpoint = "database"
  }
}


resource "juju_integration" "api_server_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_api_server.application.name
    endpoint = module.airflow_api_server.requires.airflow_coordinator
  }
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}

resource "juju_integration" "coordinator_to_api_server" {
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_api_server.application.name
    endpoint = module.airflow_api_server.provides.airflow_api_server
  }
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.requires.airflow_api_server
  }
}

resource "juju_integration" "scheduler_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_scheduler.application.name
    endpoint = module.airflow_scheduler.requires.airflow_coordinator
  }
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}

resource "juju_integration" "triggerer_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_triggerer.application.name
    endpoint = module.airflow_triggerer.requires.airflow_coordinator
  }
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}

resource "juju_integration" "dag_processor_to_coordinator" {
  model_uuid = var.model_uuid
  application {
    name     = module.airflow_dag_processor.application.name
    endpoint = module.airflow_dag_processor.requires.airflow_coordinator
  }
  application {
    name     = module.airflow_coordinator.application.name
    endpoint = module.airflow_coordinator.provides.airflow_coordinator
  }
}
