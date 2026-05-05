postgresql = {
  profile = "testing"
}

executor = "kubernetes"

airflow_kubernetes_executor = {
  config = {
    base_image = "ghcr.io/dnplas/airflow-worker:3.1.8-impersonation"
    namespace  = "airflow-executor-workers"
  }
}
