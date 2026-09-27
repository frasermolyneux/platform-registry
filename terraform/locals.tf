locals {
  workload_resource_groups_raw = data.terraform_remote_state.platform_workloads.outputs.workload_resource_groups[var.workload_name][var.environment].resource_groups

  workload_resource_groups = {
    for location, rg in local.workload_resource_groups_raw :
    lower(location) => rg
  }

  available_locations    = keys(local.workload_resource_groups)
  fallback_location      = length(local.available_locations) > 0 ? local.available_locations[0] : null
  primary_location       = contains(local.available_locations, lower(var.location)) ? lower(var.location) : local.fallback_location
  primary_resource_group = local.primary_location != null ? local.workload_resource_groups[local.primary_location] : null

  resource_tags = merge({
    Environment = var.environment,
    Workload    = var.workload_name,
  }, var.tags)

  acr_name = "acr${random_id.acr.hex}"
}
