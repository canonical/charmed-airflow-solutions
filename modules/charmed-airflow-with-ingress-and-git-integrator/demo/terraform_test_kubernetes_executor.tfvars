model_uuid = "31f24f7e-27e5-4b8c-844f-b902501cfb3f"

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
