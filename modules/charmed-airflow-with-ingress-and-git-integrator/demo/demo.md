# Hi Madrid 26.04!

# We'll deploy the whole solution using our Terraform solution module
# as a base

# We'll deploy:
# * traefik-k8s for ingress
# * git-integrator for gathering DAGs from a git repo
# * airflow-kubernetes-executor for executing tasks as Kubernetes Pods

# 1. 
# 1. Let's deploy the charms using our Terrafom solution module

terraform init
terraform apply --var-file="terraform.tfvars" -auto-approve
