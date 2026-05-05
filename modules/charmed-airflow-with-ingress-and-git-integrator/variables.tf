variable "model_uuid" {
  description = "UUID of the juju model to deploy to."
  type        = string
}

variable "airflow_api_server" {
  description = "Inputs for airflow-api-server-k8s charm module."
  type = object({
    app_name = optional(string, "airflow-api-server")
    channel  = optional(string, "3.1/edge")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "airflow_coordinator" {
  description = "Inputs for airflow-coordinator-k8s charm module."
  type = object({
    app_name = optional(string, "airflow-coordinator")
    channel  = optional(string, "3.1/edge")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "airflow_dag_processor" {
  description = "Inputs for airflow-dag-processor-k8s charm module."
  type = object({
    app_name = optional(string, "airflow-dag-processor")
    channel  = optional(string, "3.1/edge")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "airflow_scheduler" {
  description = "Inputs for airflow-scheduler-k8s charm module."
  type = object({
    app_name = optional(string, "airflow-scheduler")
    channel  = optional(string, "3.1/edge")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "airflow_triggerer" {
  description = "Inputs for airflow-triggerer-k8s charm module."
  type = object({
    app_name = optional(string, "airflow-triggerer")
    channel  = optional(string, "3.1/edge")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "executor" {
  description = "The executor type to deploy. When null, no executor charm is deployed and the default LocalExecutor is used. Supported values: \"kubernetes\"."
  type        = string
  default     = null

  validation {
    condition     = var.executor == null || contains(["kubernetes"], var.executor)
    error_message = "Unsupported executor type. Supported values: null, \"kubernetes\"."
  }
}

variable "airflow_kubernetes_executor" {
  description = "Inputs for airflow-kubernetes-executor-k8s charm module."
  type = object({
    app_name = optional(string, "airflow-kubernetes-executor")
    channel  = optional(string, "3.1/edge")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "postgresql" {
  description = "Inputs for postgresql-k8s charm module."
  type = object({
    app_name           = optional(string, "postgresql")
    channel            = optional(string, "14/stable")
    base               = optional(string, "ubuntu@22.04")
    units              = optional(number, 3)
    profile            = optional(string, "production")
    config             = optional(map(string), {})
    revision           = optional(number, null)
    storage_directives = optional(map(string), {})
  })
  default = {}
}

variable "pgbouncer" {
  description = "Inputs for pgbouncer-k8s charm"
  type = object({
    app_name = optional(string, "pgbouncer")
    channel  = optional(string, "1/stable")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "traefik" {
  description = "Inputs for traefik-k8s charm module."
  type = object({
    app_name = optional(string, "traefik")
    channel  = optional(string, "latest/stable")
    units    = optional(number, 1)
    config   = optional(map(string), {})
    revision = optional(number, null)
  })
  default = {}
}

variable "git_integrator" {
  description = "Inputs for git-integrator charm module. The repository_url, path and tracking_ref defaults point at apache/airflow example DAGs on main."
  type = object({
    app_name = optional(string, "git-integrator")
    channel  = optional(string, "1.0/edge")
    units    = optional(number, 1)
    config = optional(map(string), {
      repository_url = "https://github.com/apache/airflow"
      path           = "airflow-core/src/airflow/example_dags"
      tracking_ref   = "v3-1-stable"
    })
    revision = optional(number, null)
  })
  default = {}
}
