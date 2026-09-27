data "azuread_service_principal" "workload_acr_consumer" {
  for_each = { for consumer in var.workload_acr_consumers : consumer.name => consumer }

  display_name = each.value.identity_name
}

resource "azurerm_role_assignment" "workload_acr_consumer" {
  for_each = { for consumer in var.workload_acr_consumers : consumer.name => consumer }

  scope                = azurerm_container_registry.workload_images.id
  role_definition_name = each.value.role
  principal_id         = data.azuread_service_principal.workload_acr_consumer[each.key].object_id
  principal_type       = "ServicePrincipal"
  description          = "Repository-scoped workload image access for ${each.key}"
  condition_version    = "2.0"
  condition            = <<-CONDITION
    (
      (
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/content/read'})
        AND
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/content/write'})
        AND
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/metadata/read'})
        AND
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/metadata/write'})
      )
      OR
      (
        @Request[Microsoft.ContainerRegistry/registries/repositories:name] ${each.value.match == "prefix" ? "StringStartsWithIgnoreCase" : "StringEqualsIgnoreCase"} '${each.value.repository}'
      )
    )
  CONDITION
}
