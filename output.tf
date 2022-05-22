output "full_certificate_permissions" {
  description = "Full permissions to the certificate permission set, used as a variable in the module"
  value       = tolist(var.full_certificate_permissions)
}

output "full_key_permissions" {
  description = "Full permissions to the key permission set, used as a variable in the module"
  value       = tolist(var.full_key_permissions)
}

output "full_secret_permissions" {
  description = "Full permissions to the secret permission set, used as a variable in the module"
  value       = tolist(var.full_secret_permissions)
}

output "full_storage_permissions" {
  description = "Full permissions to the storage permission set, used as a variable in the module"
  value       = tolist(var.full_storage_permissions)
}

output "kv_id" {
  description = "The id of the keyvault"
  value       = azurerm_key_vault.keyvault.id
}

output "kv_name" {
  description = "The name of the keyvault"
  value       = azurerm_key_vault.keyvault.name
}

output "kv_tenant_id" {
  description = "The keyvault tenant id"
  value       = azurerm_key_vault.keyvault.tenant_id
}

output "sa_id" {
  value       = azurerm_storage_account.sa.id
  description = "The ID of the storage account"
}

output "sa_name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the storage account"
}

output "sa_primary_access_key" {
  value       = azurerm_storage_account.sa.primary_access_key
  description = "The primary access key of the storage account"
  sensitive   = true
}

output "sa_primary_blob_endpoint" {
  value       = azurerm_storage_account.sa.primary_blob_endpoint
  description = "The primary blob endpoint of the storage account"
}

output "sa_primary_connection_string" {
  value       = azurerm_storage_account.sa.primary_blob_connection_string
  description = "The primary blob connection string of the storage account"
  sensitive   = true
}

output "sa_secondary_access_key" {
  value       = azurerm_storage_account.sa.secondary_access_key
  description = "The secondary access key of the storage account"
  sensitive   = true
}
