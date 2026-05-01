postgresql = {
  profile = "testing"
}

executor = "kubernetes"

airflow_kubernetes_executor = {
  config = {
    base_image = "ghcr.io/dnplas/airflow:3.1.8"
    namespace  = "airflow-executor-workers"
  }
}
