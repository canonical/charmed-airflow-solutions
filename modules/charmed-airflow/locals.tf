locals {
  executor_endpoints = {
    kubernetes = {
      requires = "airflow-config"
      provides = "airflow-executor-config"
    }
  }

  # Each executor module block must be added here when a new executor type is introduced.
  executor_module = var.executor != null ? {
    kubernetes = module.airflow_kubernetes_executor[0]
  }[var.executor] : null
}
