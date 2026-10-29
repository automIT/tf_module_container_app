output "id" {
  description = "ID der Container App"
  value       = azurerm_container_app.app.id
}

output "name" {
  description = "Name der Container App"
  value       = azurerm_container_app.app.name
}

output "url" {
  description = "URL der Container App"
  value       = "https://${azurerm_container_app.app.ingress[0].fqdn}"
}
