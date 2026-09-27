resource "random_id" "acr" {
  byte_length = 6

  keepers = {
    environment = var.environment
    location    = var.location
  }
}

resource "random_id" "workload_acr" {
  byte_length = 6

  keepers = {
    environment = var.environment
    location    = var.location
    purpose     = "workload-images"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.rg[local.primary_location].name
  location            = data.azurerm_resource_group.rg[local.primary_location].location
  sku                 = var.acr_sku
  admin_enabled       = false

  tags = local.resource_tags
}

resource "azurerm_container_registry" "workload_images" {
  #checkov:skip=CKV_AZURE_139:Public access is required for GitHub-hosted OIDC publishers and non-Azure bare-metal hosts; ABAC controls repository access.
  #checkov:skip=CKV_AZURE_163:Promotion validates immutable digests, image metadata, and workload health instead of relying on ACR quarantine.
  #checkov:skip=CKV_AZURE_164:Workloads use reviewed immutable digests and reject undeclared image volumes; Docker Content Trust is not the delivery boundary.
  #checkov:skip=CKV_AZURE_165:The registry serves single-region bare-metal hosts and does not require geo-replication.
  #checkov:skip=CKV_AZURE_166:Registry vulnerability assessment is managed by the subscription security posture rather than an ACR resource property.
  #checkov:skip=CKV_AZURE_167:Dedicated data endpoints require Premium; repository ABAC protects this low-volume Basic registry over its public endpoint.
  #checkov:skip=CKV_AZURE_233:The single-region workload registry does not require Premium zone redundancy.
  #checkov:skip=CKV_AZURE_237:Images are digest-pinned release artifacts; lifecycle cleanup will be introduced separately after retention requirements are measured.
  name                 = local.workload_acr_name
  resource_group_name  = data.azurerm_resource_group.rg[local.primary_location].name
  location             = data.azurerm_resource_group.rg[local.primary_location].location
  sku                  = var.acr_sku
  admin_enabled        = false
  role_assignment_mode = "AbacRepositoryPermissions"

  tags = merge(local.resource_tags, {
    Purpose = "workload-images"
  })
}
