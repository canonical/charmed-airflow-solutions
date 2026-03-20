# Charmed Airflow Terraform Solution

This is a Terraform module that deploys the Charmed Airflow stack using the [Terraform Juju provider](https://github.com/juju/terraform-provider-juju/).
For provider configuration, see the [Terraform provider documentation](https://registry.terraform.io/providers/juju/juju/latest/docs).

---

## Architecture Overview

This module deploys the following components and their relations:

| Component | Charm | Role |
| --- | --- | --- |
| `postgresql` | `postgresql-k8s` | Backend metadata database. |
| `pgbouncer` | `pgbouncer-k8s` | Connection pooling proxy for metadata database access. |
| `airflow-coordinator` | `airflow-coordinator-k8s` | Central coordinator for configuration and migrations. |
| `airflow-api-server` | `airflow-api-server-k8s` | REST API endpoint for Airflow. |
| `airflow-scheduler` | `airflow-scheduler-k8s` | Schedules and triggers task instances. |
| `airflow-triggerer` | `airflow-triggerer-k8s` | Runs async triggers for deferrable operators. |
| `airflow-dag-processor` | `airflow-dag-processor-k8s` | Parses DAGs and serializes them to the DB. |
| `airflow-executor` (optional) | Executor-specific charm (e.g. `airflow-kubernetes-executor-k8s`) | Configures the Airflow executor type and related settings. Deployed only when `executor` is set. |

---

## API

### Inputs

| Name | Type | Description | Required |
| --- | --- | --- | --- |
| `model_uuid` | string | Reference to an existing Juju model to deploy Airflow into | true |
| `executor` | string | Executor type to deploy (e.g. `"kubernetes"`). When `null`, no executor charm is deployed and Airflow uses the default `LocalExecutor`. | false |
| `airflow_kubernetes_executor` | object | Configuration for the `airflow-kubernetes-executor-k8s` charm module. Only used when `executor = "kubernetes"`. | false |
| `postgresql` | object | Configuration for the `postgresql-k8s` charm module | false |
| `pgbouncer` | object | Configuration for the `pgbouncer-k8s` charm | false |
| `airflow_coordinator` | object | Configuration for the `airflow-coordinator-k8s` charm module | false |
| `airflow_api_server` | object | Configuration for the `airflow-api-server-k8s` charm module | false |
| `airflow_scheduler` | object | Configuration for the `airflow-scheduler-k8s` charm module | false |
| `airflow_triggerer` | object | Configuration for the `airflow-triggerer-k8s` charm module | false |
| `airflow_dag_processor` | object | Configuration for the `airflow-dag-processor-k8s` charm module | false |


Each Airflow charm input object supports:

| Field | Type | Description | Default |
| --- | --- | --- | --- |
| `app_name` | string | Application name to deploy | Charm-specific |
| `channel` | string | Charm channel to deploy from | `3.1/edge` |
| `revision` | number | Charm revision to use | `null` |
| `units` | number | Number of application units | `1` |
| `config` | map(string) | Charm-specific configuration options | `{}` |

The PostgreSQL input object supports:

| Field | Type | Description | Default |
| --- | --- | --- | --- |
| `app_name` | string | Application name to deploy | `postgresql` |
| `channel` | string | Charm channel to deploy from | `14/stable` |
| `base` | string | Base to deploy the application with | `ubuntu@22.04` |
| `revision` | number | Charm revision to use | `null` |
| `units` | number | Number of application units | `3` |
| `storage_directives` | map(string) | Storage directives to apply | `{}` |
| `config` | map(string) | Charm configuration options | `{}` |

---

### Outputs

| Name | Description |
| --- | --- |
| `applications` | Map containing all charm modules that make up the Charmed Airflow deployment |

---

## Relations

The following relations are automatically established:

| Integration | Purpose |
| --- | --- |
| `postgresql ↔ pgbouncer` | Backend database integration providing the primary data store and schema management. |
| `airflow-coordinator ↔ pgbouncer` | Metadata database connectivity and migrations. |
| `airflow-api-server ↔ airflow-coordinator` | API server registration and configuration. |
| `airflow-scheduler ↔ airflow-coordinator` | Scheduler registration and configuration. |
| `airflow-triggerer ↔ airflow-coordinator` | Triggerer registration and configuration. |
| `airflow-dag-processor ↔ airflow-coordinator` | DAG processor registration and configuration. |
| `airflow-executor ↔ airflow-coordinator` (when `executor` is set) | Executor configuration exchange. The coordinator sends global Airflow config to the executor, and the executor sends back executor-specific settings (e.g. pod templates). |

---

## Usage

This solution module can be used standalone or as part of a higher-level Terraform orchestration layer.

### Example: Basic Deployment (LocalExecutor)

By default, no executor charm is deployed and Airflow uses the `LocalExecutor`:

```hcl
model_uuid = "<model-uuid>"
```

### Example: KubernetesExecutor

To deploy with the `KubernetesExecutor`, set `executor = "kubernetes"` and provide the required executor configuration:

```hcl
model_uuid = "<model-uuid>"

executor = "kubernetes"

airflow_kubernetes_executor = {
  config = {
    namespace  = "airflow-workers"
    base_image = "your-registry/airflow:3.1"
  }
}
```

The `airflow_kubernetes_executor` input object supports the same fields as other Airflow charm inputs (`app_name`, `channel`, `revision`, `units`, `config`). The `config` map is passed directly to the charm and supports the following charm-specific options:

| Option | Type | Required | Description |
| --- | --- | --- | --- |
| `namespace` | string | yes | Kubernetes namespace where worker Pods will be scheduled. Must already exist. |
| `base_image` | string | yes | OCI image for worker Pods. For Local DAG bundle sources, this image must contain the DAGs. |
| `pod_name` | string | no | Base name for worker Pods (default: `airflow-worker`). |

### Running

```bash
terraform apply -var-file=test/terraform_test_local_executor.tfvars
```

For module validation and smoke tests (including `kgoss` service/API/DB checks):

```bash
just test
```

`just test` uses [test/terraform_test_local_executor.tfvars](test/terraform_test_local_executor.tfvars), runs `kgoss` checks for:
- Airflow API health endpoint (`http://airflow-api-server-endpoints.airflow-test.svc.cluster.local:8080/api/v2/monitor/health`)
- Healthy statuses for `metadatabase`, `scheduler`, `triggerer`, and `dag_processor`
- Scheduler DB connectivity using `airflow db check`
- `airflow.cfg` existence at `${AIRFLOW_HOME}/airflow.cfg` in:
	- `airflow-api-server-0`
	- `airflow-dag-processor-0`
	- `airflow-triggerer-0`
	- `airflow-scheduler-0`

---

### Cleanup

To remove the deployment and destroy the associated Juju model:

```bash
just destroy test/terraform_test_local_executor.tfvars
```

---

## Repository References

- https://github.com/canonical/airflow-coordinator-k8s-operator
- https://github.com/canonical/airflow-core-operators
- https://github.com/canonical/airflow-kubernetes-executor-k8s-operator
- https://github.com/canonical/postgresql-k8s-operator
