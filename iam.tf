resource "azurerm_role_assignment" "sa_operator_role_assignment" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = "727055f9-0386-4ccb-bcf1-9237237ee102"
}