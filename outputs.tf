output "app_domain" {
  value       = var.app_domain
  description = "The name of the created domain."
  depends_on = [
    datapower_domain.this,
  ]
}

output "system_settings" {
  value       = var.app_domain == "default" && var.system_settings != null ? datapower_system_settings.this : null
  description = "Default domain system settings"
  depends_on = [
    datapower_system_settings.this,
  ]
}
