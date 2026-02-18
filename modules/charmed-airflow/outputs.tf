output "applications" {
  description = "All charm modules which make up this product module."
  value = {
    postgresql = module.postgresql
    airflow = {
      coordinator   = module.airflow_coordinator
      api_server    = module.airflow_api_server
      scheduler     = module.airflow_scheduler
      triggerer     = module.airflow_triggerer
      dag_processor = module.airflow_dag_processor
    }
  }
}
