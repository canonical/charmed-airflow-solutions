#!/usr/bin/env bash
set -euo pipefail

# Set some variables
hash=$(openssl rand -hex 2)
MODEL_NAME=airflow-demo-$hash
KUBERNETES_NAMESPACE=airflow-executor-workers-$hash
TFVARS_FILE=./terraform_test_kubernetes_executor.tfvars

# Create a Kubernetes namespace for the DAG tasks to be scheduled to
kubectl create ns $KUBERNETES_NAMESPACE

# Add the juju model and get its UUID
juju add-model $MODEL_NAME
MODEL_UUID=$(juju show-model $MODEL_NAME | yq ".\"$MODEL_NAME\".model-uuid")

# Drop any pre-existing model_uuid line so re-running this script stays idempotent
sed -i '/^model_uuid[[:space:]]*=/d' $TFVARS_FILE
# Append the model-uuid to the .tfvars file
echo "model_uuid = \"$MODEL_UUID\"" >> $TFVARS_FILE

# Replace the kubernetes executor namespace (matches the placeholder or any
# previously-substituted hash suffix) with the one just created
sed -i -E "s|namespace([[:space:]]+)= \"airflow-executor-workers(-[a-z0-9]+)?\"|namespace\\1= \"$KUBERNETES_NAMESPACE\"|" $TFVARS_FILE
