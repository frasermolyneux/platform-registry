output "acr" {
  value = {
    id           = azurerm_container_registry.acr.id
    name         = azurerm_container_registry.acr.name
    login_server = azurerm_container_registry.acr.login_server
  }
}

output "workload_acr" {
  value = {
    id           = azurerm_container_registry.workload_images.id
    name         = azurerm_container_registry.workload_images.name
    login_server = azurerm_container_registry.workload_images.login_server
  }
}
