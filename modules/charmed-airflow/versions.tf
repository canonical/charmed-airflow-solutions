# CC008: spec prefers terraform.tf; keep versions.tf to match repository conventions.
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">= 1.0.0"
    }
  }
}
