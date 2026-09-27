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
