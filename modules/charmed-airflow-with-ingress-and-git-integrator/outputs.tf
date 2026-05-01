output "applications" {
  description = "All charm modules which make up this product module."
  value = merge(
    module.charmed_airflow.applications,
    {
      traefik        = module.traefik
      git_integrator = module.git_integrator
    }
  )
}
