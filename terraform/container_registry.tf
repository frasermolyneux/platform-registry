resource "random_id" "acr" {
  byte_length = 6

  keepers = {
    environment = var.environment
    location    = var.location
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
