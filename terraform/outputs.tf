output "acr" {
  value = {
    id           = azurerm_container_registry.acr.id
    name         = azurerm_container_registry.acr.name
    login_server = azurerm_container_registry.acr.login_server
  }
}
