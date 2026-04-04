data "azuread_service_principal" "acr_consumer" {
  for_each = { for c in var.acr_consumers : c.workload => c }

  display_name = each.value.identity_name
}

resource "azurerm_role_assignment" "acr_consumer" {
  for_each = { for c in var.acr_consumers : c.workload => c }

  scope                = azurerm_container_registry.acr.id
  role_definition_name = each.value.role
  principal_id         = data.azuread_service_principal.acr_consumer[each.key].object_id
}
