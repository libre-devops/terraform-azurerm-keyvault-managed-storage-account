resource "azurerm_role_assignment" "sa_operator_role_assignment" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = "cfa8b339-82a2-471a-a3c9-0fc0be7a4093"

  timeouts {
    create = "5m"
  }
}