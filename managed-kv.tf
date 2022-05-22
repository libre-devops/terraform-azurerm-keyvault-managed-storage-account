resource "azurerm_key_vault_managed_storage_account" "sa_kv_iam" {
  name                         = azurerm_storage_account.sa.name
  key_vault_id                 = azurerm_key_vault.keyvault.id
  storage_account_id           = azurerm_storage_account.sa.id
  storage_account_key          = var.storage_account_key_to_regenerate
  regenerate_key_automatically = var.regenerate_keys_automatically
  regeneration_period          = var.regenerate_keys_automatically == true ? var.regeneration_period : null
  tags                         = var.tags
}