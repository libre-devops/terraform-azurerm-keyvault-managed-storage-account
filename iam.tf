resource "azurerm_role_assignment" "sa_operator_role_assignment" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = "2f52b87a-b032-421f-b0fb-3c8be030d053" // Azure Key Vault service role in tenant

  timeouts {
    create = "5m"
  }
}