resource "random_id" "acr" {
  byte_length = 6

  keepers = {
    environment = var.environment
    location    = var.location
  }
}

resource "azurerm_container_registry" "acr" {
  # checkov:skip=CKV_AZURE_163:Vulnerability scanning is configured through subscription-level Microsoft Defender for Containers, not on the registry resource.
  # checkov:skip=CKV_AZURE_164:ACR content trust is deprecated; immutable digest promotion and deployment policy enforce trusted images.
  # checkov:skip=CKV_AZURE_166:Image quarantine is a Premium preview feature and is not supported by this cost-optimised shared registry.
  # checkov:skip=CKV_AZURE_167:Untagged manifest retention is a Premium-only feature and is not supported by the configured Basic SKU.
  # checkov:skip=CKV_AZURE_237:Dedicated data endpoints require Premium and are inapplicable to the configured Basic SKU.
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.rg[local.primary_location].name
  location            = data.azurerm_resource_group.rg[local.primary_location].location
  sku                 = var.acr_sku
  admin_enabled       = false

  tags = local.resource_tags
}
