# Charmed Airflow Terraform Solution

This is a Terraform module that deploys the Charmed Airflow stack using the [Terraform Juju provider](https://github.com/juju/terraform-provider-juju/).
For provider configuration, see the [Terraform provider documentation](https://registry.terraform.io/providers/juju/juju/latest/docs).

---

## Architecture Overview

This module deploys the following components and their relations:

| Component | Charm | Role |
| --- | --- | --- |
| `postgresql` | `postgresql-k8s` | Backend metadata database. |
| `airflow-coordinator` | `airflow-coordinator-k8s` | Central coordinator for configuration and migrations. |
| `airflow-api-server` | `airflow-api-server-k8s` | REST API endpoint for Airflow. |
| `airflow-scheduler` | `airflow-scheduler-k8s` | Schedules and triggers task instances. |
| `airflow-triggerer` | `airflow-triggerer-k8s` | Runs async triggers for deferrable operators. |
| `airflow-dag-processor` | `airflow-dag-processor-k8s` | Parses DAGs and serializes them to the DB. |

---

## API

### Inputs

| Name | Type | Description | Required |
| --- | --- | --- | --- |
| `model_uuid` | string | Reference to an existing Juju model to deploy Airflow into | true |
| `postgresql` | object | Configuration for the `postgresql-k8s` charm module | false |
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
| `constraints` | string | Juju constraints for the application | `null` |
| `config` | map(string) | Charm-specific configuration options | `{}` |

The PostgreSQL input object supports:

| Field | Type | Description | Default |
| --- | --- | --- | --- |
| `app_name` | string | Application name to deploy | `postgresql` |
| `channel` | string | Charm channel to deploy from | `14/stable` |
| `base` | string | Base to deploy the application with | `ubuntu@22.04` |
| `revision` | number | Charm revision to use | `null` |
| `units` | number | Number of application units | `1` |
| `constraints` | string | Juju constraints for the application | `arch=amd64` |
| `storage_directives` | map(string) | Storage directives to apply | `{}` |
| `resources` | map(string) | Resource overrides | `{}` |
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
| `airflow-coordinator ↔ postgresql` | Metadata database connectivity and migrations. |
| `airflow-api-server ↔ airflow-coordinator` | API server registration and configuration. |
| `airflow-scheduler ↔ airflow-coordinator` | Scheduler registration and configuration. |
| `airflow-triggerer ↔ airflow-coordinator` | Triggerer registration and configuration. |
| `airflow-dag-processor ↔ airflow-coordinator` | DAG processor registration and configuration. |

---

## Usage

This solution module can be used standalone or as part of a higher-level Terraform orchestration layer.

### Example: Basic Deployment

```bash
terraform apply -var-file=terraform_test.tfvars
```

Sample `terraform_test.tfvars`:

```hcl
model_uuid = "<model-uuid>"
```

---

### Cleanup

To remove the deployment and destroy the associated Juju model:

```bash
just destroy ./terraform_test.tfvars
```

---

## Repository References

- https://github.com/canonical/airflow-coordinator-k8s-operator
- https://github.com/canonical/airflow-core-operators
- https://github.com/canonical/postgresql-k8s-operator
