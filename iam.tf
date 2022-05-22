resource "azurerm_role_assignment" "sa_operator_role_assignment" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = var.azure_kv_object_id // Azure Key Vault service role in tenant

  timeouts {
    create = "5m"
  }
}